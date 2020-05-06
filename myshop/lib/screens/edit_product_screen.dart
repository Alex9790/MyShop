import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

//clase utilizada para agregar o editar productos
class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  //identifica el Focus de un TextField
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  //se quiere mostrar el preview de la imagen antes de hacer submit, asi que se necesita de un Controlador
  final _imageUrlController = TextEditingController();
  //se agrega focusNode al url de la imagen de tal forma que se renderice la imagen cuando se pierda el focus de este input
  final _imageUrlFocusNode = FocusNode();
  //con esta ariable global se tendra acceso a los datos obtenidos en el Widget Form
  final _form = GlobalKey<FormState>();
  //pedido inicializado, que sera actualizado con los inputs del Form
  var _editedProduct =
      Product(id: null, title: "", description: "", price: 0, imageUrl: "");
  //para que se ejecute solo una vez al iniciar el Widget
  var _isInit = true;
  //valores iniciales del formulario, que pueden ser alterados en caso de que se vaya a editar un producto existente
  var _initValues = {
    "title": "",
    "description": "",
    "price": "",
    "imageUrl": "",
  };

  //se crea un Listener para _imageUrlFocusNode al inicio de esta pantalla
  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  //se ejecuta periodicamente cuando se cambia el estado
  @override
  void didChangeDependencies() {
    if (_isInit) {
      //se obtiene el id que viene por parametro aqi, porque ModalRoute aun no esta listo cuando se ejecuta "initState()"
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          "title": _editedProduct.title,
          "description": _editedProduct.description,
          "price": _editedProduct.price.toString(),
          //"imageUrl": _editedProduct.imageUrl,
        };
        //para inicializar el Input del URL
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    super.didChangeDependencies();
  }

  //los FocusNode debe ser eliminados cuando se limpia el estado de este Widget, cuando dejas esta pantalla
  //sino se mantienen en memoria creando problemas de memoria
  @override
  void dispose() {
    super.dispose();
    //los listener tambien se quedan en memoria a pesar de que se cierra la pantalla, asi que deben ser limpiados
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
  }

  void _updateImageUrl() {
    //cuando se pierde el focus del input
    if (!_imageUrlFocusNode.hasFocus) {
      //se pueden agregar las mismas validaciones incluidas en el validator en este punto, pero utilizando _imageUrlFocusNode.text en vez de value
      //para que refresque pantalla
      setState(() {});
    }
  }

  void _saveForm() {
    //metodo para ejecutar todas las validaciones definidas en los "validator" de cada TextFormField()
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    //metodo de Flutter para guardar los datos del formulario
    _form.currentState.save();

    //_editedProduct tendra solo id cuando se esta editando, asi que se usa esta vaidacion para identificar cuando este es el caso
    if (_editedProduct.id != null) {
      //se editan los datos de un producto especificado
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      //se realiza el insert a la lista de productos
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }

    //para descartar esta pantalla y dirigirnos a la anterior que muestra todos los productos
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Producto"),
        actions: <Widget>[
          IconButton(
            //buton para hacer submit al Form
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      //permite gestionar mejor los datos de entrada sin necesidad de hacerlo manualmente usando controladores
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          //para indicarle al form que utilice esta GlobalKey
          key: _form,
          child: ListView(
            children: <Widget>[
              //se conecta automaticamente con Form()
              TextFormField(
                //para setear el valor inicial del input
                initialValue: _initValues["title"],
                decoration: InputDecoration(labelText: "Title"),
                //esto permite que a darle a la flecha en la esquina inferior derecha del teclado, pase al siguiente Input del formulario en vez de hacer Submit
                textInputAction: TextInputAction.next,
                //se ejecuta cuando el boton inferior derecho del teclado es presionado, toma como parametro el valor del textField
                onFieldSubmitted: (value) {
                  //al presionar el boton solo cambiar el foco al textField identificado por el FocusNode seleccionado
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                //funcion que se ejecuta cuando es ejecutado el metodo .save al hacer submit
                onSaved: (value) {
                  //Product se llena por parte, pero como todos sus argumentos son final, se llenan de esta manera, creando un Product nuevo con los datos del viejo
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: value,
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Debe llenar este campo.";
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues["price"],
                decoration: InputDecoration(labelText: "Price"),
                textInputAction: TextInputAction.next,
                //define el tipo de teclado que se mostrara
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    price: double.parse(value),
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Debe llenar este campo.";
                  }
                  //retorna null si el numero es invalido, en vez de una excepcion, ideal para validar si es un numero
                  if (double.tryParse(value) == null) {
                    return "Debe ingresar un valor válido.";
                  }
                  if (double.parse(value) <= 0) {
                    return "Debe ingresar un valor mayor a cero.";
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues["description"],
                decoration: InputDecoration(labelText: "Descripcion"),
                //tomando en cuenta que este campo puede ser mas largo
                //muestra en pantalla simultaneamente tres lineas, pero se puede escribir tanto como se permita
                maxLines: 3,
                //un teclado mas util para este tipo de inputs
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: value,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Debe llenar este campo.";
                  }
                  if (value.length < 10) {
                    return "Debe ingresar un minimo de 10 carácteres.";
                  }
                  return null;
                },
              ),
              //contendra un preview de la imagen a cargar y la direccion
              Row(
                //mueve todo el contenido hacia "el piso digamos" den espacio definido
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    //Se realiza un peticion para mostrar un preview de la imagen si se encuentra la url en el input
                    child: _imageUrlController.text.isEmpty
                        ? Text("Colocar Url de la Imagen")
                        : FittedBox(
                            child: Image.network(_imageUrlController.text),
                            fit: BoxFit.cover,
                          ),
                  ),
                  Expanded(
                    child: TextFormField(                      
                      decoration: InputDecoration(
                        labelText: "Image URL",
                      ),
                      keyboardType: TextInputType.url,
                      //cuando presione "enter" se intentara hacer submit
                      textInputAction: TextInputAction.done,
                      //se agrega controlador, porque se desea obtener el valor antes de submit
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      //este es el ultimo input, asi que en el teclado en pantalla se vera un check, el cual queremos que haga submit tambien
                      //el parametro "value" es el valor del input, en este caso no se necesita asi que se puede cambiar por (_)
                      onFieldSubmitted: (value) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: value,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Debe llenar este campo.";
                        }
                        if (!value.startsWith("http") &&
                            !value.startsWith("https")) {
                          return "El enlace no es válido, debe incluir el protocolo 'http' o 'https'.";
                        }
                        if (!value.endsWith(".png") &&
                            !value.endsWith(".jpg") &&
                            !value.endsWith(".jpeg")) {
                          return "Debe ingresar una imagen válida.";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
