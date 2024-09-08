import 'package:cengodelivery/src/interfaces/order.dart';
import 'package:cengodelivery/src/pages/page_retire_orders.dart';
import 'package:cengodelivery/src/providers/order_provider.dart';
import 'package:cengodelivery/src/widgets/component_button_custom.dart';
import 'package:cengodelivery/src/widgets/component_order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComponentListOrder extends StatelessWidget {
  final List<Order> orders;
  //final Map<String, dynamic> counters;
  final VoidCallback onInitRouting;
  final bool isEmbedded;

  const ComponentListOrder({
    Key? key,
    required this.orders,
    //required this.counters,
    this.isEmbedded = false,
    required this.onInitRouting,
  }) : super(key: key);

  static const routeName = '/listorder';

  @override
  Widget build(BuildContext context) {
    print('Construyendo ComponentListOrder');
    print('Número de órdenes: ${orders.length}');

    Widget content = Column(
      children: [
        // _buildHeader(counters),
        Expanded(
          child: Container(
            color: Colors.grey.withOpacity(0.1),
            child: _buildOrderList(orders),
          ),
        ),
        _buildRetireButton(context),
      ],
    );

    if (isEmbedded) {
      return content;
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Listado de Órdenes'),
        ),
        body: content,
      );
    }
  }

  Widget _buildHeader(Map<String, dynamic> counters) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCounter('Retirados', counters['retirados']),
          _buildCounter('Entregados', counters['entregados']),
        ],
      ),
    );
  }

  Widget _buildCounter(String title, dynamic count) {
    return Column(
      children: [
        Text(title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(count.toString(), style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return ComponentOrderItem(order: orders[index]);
      },
    );
  }

  void _goPageRetireProducts(BuildContext context) {
    // Aquí puedes agregar la lógica de validación de inicio de sesión
    // Por ahora, simplemente navegaremos a la pantalla de inicio
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PageRetireOrders(orderIndex: 0)),
    );
  }

  Widget _buildRetireButton(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final orderProvider = Provider.of<OrderProvider>(context);
    print('orderProvider.allOrdersHaveImages()');
    print(orderProvider.allOrdersHaveImages());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              child: orderProvider.allOrdersHaveImages()
                  ? ComponentButtonCustom(
                      text: 'Iniciar Recorrido',
                      backgroundColor: colorScheme.primary,
                      onPressed: () {
                        print("onInitRouting");
                        onInitRouting();
                      },
                    )
                  : ComponentButtonCustom(
                      text: 'Retirar Pedidos',
                      backgroundColor: colorScheme.primary,
                      onPressed: () {
                        // Acción del botón
                        _goPageRetireProducts(context);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
