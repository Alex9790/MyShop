import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
//import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  //este token por motivos de segurida tiene un tiempo limite
  String _token;
  //fecha limite del token
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

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

  String get userId {
    return _userId;
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

      //se consulta aqui, porque es cuando el usuario es oficialmente autenticado
      _autoLogout();
      notifyListeners();

      //Para gestionar shared preferences - se almacenan datos de sesion
/*      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          "token": _token,
          "userId": _userId,
          "expiryDate": _expiryDate.toIso8601String()
        },
      );
      prefs.setString("userData", userData);
*/      
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

  Future<bool> tryAutoLogin() async {
/*    print("aqui");
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }

    final extractedUserData = json.decode(prefs.getString("userData")) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData["expiryDate"]);

    //chequeando expiracion del token
    if (expiryDate.isBefore(DateTime.now())) {
      return false;      
    }

    //en este punto el token es valido y se setean las variables de sesion
    _token = extractedUserData["token"];
    _userId = extractedUserData["userId"];
    _expiryDate = expiryDate;
    notifyListeners();
    //para setear el timer
    _autoLogout();
    return true;
*/    
    return false;
  }

  Future<void> logout() async{
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();

    //limpiando shared preferences
//    final prefs = await SharedPreferences.getInstance();
    //cuando solo se qiere limpiar data especifica
    //prefs.remove("userData");
    //cuando se qiere limpiar toda la data
//    prefs.clear();
  }

  void _autoLogout() {
    //se cancela el timer actual, para actualizarlo
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    //permite calcular la diferencia en segundos entre el momento actual y la fecha de vencimiento del token
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    //cuando se venza el plazo se ejecutara logout()
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
