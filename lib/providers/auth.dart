import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryDate;

  bool get isAuth {
    return _token != null;
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
      notifyListeners();
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
}
