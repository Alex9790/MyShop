import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders; //para solo importar Orders
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = "/orders";

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    //para permitir el uso de Future en initState y of.(context)
/*    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      //con listen: false, se puede utilizar este metodo sin Future.delayed(Duration.zero)
      await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();

      setState(() {
        _isLoading = false;
      });
    });
*/
  }

  @override
  Widget build(BuildContext context) {
    //al usar el widget FutureBuilder() esta linea genera ciclo infinito, se debe usar Consumer()
    //final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedidos"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            //significa que esta esperando/loading
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              //gestionde errores
              return Center(
                child: Text("Ha ocurrido un error."),
              );
            } else {
              //se usa consumer aqui, de lo contrario genera un ciclo infinito
              return Consumer<Orders>(
                builder: (context, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (context, index) =>
                      OrderItem(orderData.orders[index]),
                ),
              );
            }
          }
        },
      ),
      /*_isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (context, index) =>
                  OrderItem(orderData.orders[index]),
            ),
      */
    );
  }
}
