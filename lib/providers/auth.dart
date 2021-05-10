import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryDate;
  Timer _timer;

  bool get isAuth {
    return _token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  Future<void> _authanticate(email, password, segment) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:$segment?key=AIzaSyA_56sLzQZKRvcXuCwBALM1eCF3T3DDZtQ");
    try {
      final res = await http.post(
        url,
        body: jsonEncode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );
      final resJson = jsonDecode(res.body);

      if (resJson["error"] != null) {
        throw HttpException(resJson["error"]["message"]).message;
      }
      _token = resJson["idToken"];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            resJson["expiresIn"],
          ),
        ),
      );
      _userId = resJson["localId"];
      autoLogout();
      notifyListeners();
      final userData = json.encode({
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate.toIso8601String(),
      });
      final pref = await SharedPreferences.getInstance();
      pref.setString("userData", userData);
    } catch (e) {
      throw e;
    }
  }

  Future<void> signup(email, password) async {
    return _authanticate(email, password, "signUp");
  }

  Future<void> login(email, password) async {
    return _authanticate(email, password, "signInWithPassword");
  }

  Future<bool> autoLogin() async {
    try {
      final pref = await SharedPreferences.getInstance();

      if (!pref.containsKey("userData")) {
        return false;
      }
      final extractedData = json.decode(pref.getString("userData"));
      final expireDate = DateTime.parse(extractedData["expiryDate"]);
      if (expireDate.isBefore(DateTime.now())) {
        return false;
      }
      _token = extractedData["token"];
      _userId = extractedData["userId"];
      _expiryDate = DateTime.parse(extractedData["expiryDate"]);
      autoLogout();
      notifyListeners();
      return true;
    } catch (e) {
      print("eeee$e");
      return false;
    }
  }

  void logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_timer != null) {
      _timer.cancel();
    }
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  void autoLogout() {
    if (_timer != null) {
      _timer.cancel();
    }
    final timeToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
    _timer = Timer(Duration(seconds: timeToExpire), logout);
  }
}
