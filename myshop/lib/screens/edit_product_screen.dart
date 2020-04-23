import 'package:flutter/material.dart';

//clase utilizada para agregar o editar productos
class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {

  //identifica el Focus de un TextField
  final _priceFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Producto"),
      ),
      //permite gestionar mejor los datos de entrada sin necesidad de hacerlo manualmente usando controladores
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: <Widget>[
              //se conecta automaticamente con Form()
              TextFormField(
                decoration: InputDecoration(labelText: "Title"),
                //esto permite que a darle a la flecha en la esquina inferior derecha del teclado, pase al siguiente Input del formulario en vez de hacer Submit
                textInputAction: TextInputAction.next,
                //se ejecuta cuando el boton inferior derecho del teclado es presionado, toma como parametro el valor del textField
                onFieldSubmitted: (value) {
                  //al presionar el boton solo cambiar el foco al textField identificado por el FocusNode seleccionado
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Price"),                
                textInputAction: TextInputAction.next,
                //define el tipo de teclado que se mostrara
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
