import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_shop/models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _userId;
  String
      _token; // that reach endpoints that do need authentication, this token expires
  DateTime _expireyDate; // the expiry date of the token
  Timer _authTimer;

  bool get isAuth {
    // if we have a token and the token didn't expire,
    // then the user is authenticated
    return token != null;
  }

  String get token {
    if (_expireyDate != null &&
        _expireyDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signup(String email, String password) async {
    const urlSegment = 'signUp';
    return _authenticate(email, password, urlSegment);
  }

  Future<void> login(String email, String password) async {
    const urlSegment = 'signInWithPassword';
    return _authenticate(email, password, urlSegment);
  }

  Future<String> get userId {
    return Future.value(_userId);
  }

  String get userUId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDFyeig8ZZlhjtaXKjn6hJC1f5JqAioi6k';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      var responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        // if the error property exists
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expireyDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));

      _autoLogout();
      notifyListeners(); // tell all listening ui there's a change
      // working with shared preferences also works with Futures
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expireyDate,
      });
      prefs.setString('userData', userData);
    } catch (err) {
      throw err;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expireyDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expireyDate.isBefore(DateTime.now())) {
      //  the token is invalid
      return false;
    }
    // reinitialize the values
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expireyDate = expireyDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  void logout() async {
    _token = null;
    _userId = null;
    _expireyDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear(); // to clear the data persisted by the sharedpreferences
  }

  void _autoLogout() {
    // cancel existing timers if available
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    // set a timeout that expires when the token expires
    // and automatically logout
    final timeToExpiry = _expireyDate.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: timeToExpiry), logout);
  }
}
