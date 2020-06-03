import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  //este token por motivos de segurida tiene un tiempo limite
  String _token;
  //fecha limite del token
  DateTime _expiryDate;
  String _userId;

  //si tiene token y aun no esta vencido, entonces esta autenticado
  bool get isAuth {
    return _token != null;
  }

  //retorna el token asignado
  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBLNK_lKt4CInNbZRf_YEXgn1hiKWj3_n4";

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );
      print(json.decode(response.body));

      //manejo de errores retornados por firebase
      final responseData = json.decode(response.body);
      if (responseData["error"] != null) {
        //manejode errores con la clase de excepciones creada previamente
        throw HttpException(responseData["error"]["message"]);
      }
      //en caso de no haber error se toma el token y userId
      _token = responseData["idToken"];
      _userId = responseData["localId"];
      //para obtener la fecha de expiracion, se recibe del response "expiresIn" el cual es un vaor en segundos, se toma la fecha actual mas esos segundo
      //para obtener la fecha de vencimiento
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData["expiresIn"]),
        ),
      );
      notifyListeners();
    } catch (error) {
      //manejo de error por conexion http
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }
}
