import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {
  //este token por motivos de segurida tiene un tiempo limite
  String _token;  
  //fecha limite del token
  DateTime _expiryDate;
  String _userId;

  Future<void> signup(String email, String password) async {
    
    const url = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBLNK_lKt4CInNbZRf_YEXgn1hiKWj3_n4";

    final response = await http.post(url, body: json.encode({
      "email": email,
      "password": password,
      "returnSecureToken": true,
    },),);

    print(json.decode(response.body));
  }




}