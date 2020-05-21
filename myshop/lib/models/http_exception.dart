//Clase para gestionar excepciones cuando hay errores http
class HttpException implements Exception{
  final String message;

  HttpException(this.message);

  @override
  String toString() {    
    //return super.toString();  //instancia de HttpException
    return message;
  }

}