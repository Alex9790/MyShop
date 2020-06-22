import 'package:flutter/material.dart';

//Clase para agregar animacion a pantallas individualmente
class CustomRoute<T> extends MaterialPageRoute<T> {
  //Flutter ya viene con una configuracion por defecto, con este constructor todo queda igual, aun no se cambia nada
  CustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(
          builder: builder,
          settings: settings,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // TODO: implement buildTransitions
    //return super.buildTransitions(context, animation, secondaryAnimation, child);
    //esto es la primera pantalla, en ese caso no se agrega animacon a esa panatalla y solo se retorna
    if (settings.isInitialRoute) {
      return child;
    }

    //sino, si es otra panatalla interna de la app, se agrega animacio Fade
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

//Clase para agregar transicion a todas las pantallas
class CustomPageTransitionBuilder extends PageTransitionsBuilder {


  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // TODO: implement buildTransitions
    //return super.buildTransitions(context, animation, secondaryAnimation, child);
    //esto es la primera pantalla, en ese caso no se agrega animacon a esa panatalla y solo se retorna
    if (route.settings.isInitialRoute) {
      return child;
    }

    //sino, si es otra panatalla interna de la app, se agrega animacio Fade
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

}