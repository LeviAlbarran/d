import 'dart:convert';
import 'package:cengodelivery/src/interfaces/order.dart';
import 'package:cengodelivery/src/pages/page_retire_orders.dart';
import 'package:cengodelivery/src/widgets/component_button_custom.dart';
import 'package:cengodelivery/src/widgets/component_order_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class PageListOrder extends StatefulWidget {
  @override
  _PageListOrderState createState() => _PageListOrderState();
  static const routeName = '/listorder';
}

class _PageListOrderState extends State<PageListOrder> {
  late Future<Map<String, dynamic>> _orderDataFuture;

  @override
  void initState() {
    super.initState();
    _orderDataFuture = loadJsonData();
  }

  Future<Map<String, dynamic>> loadJsonData() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/data/orders_data.json');
      print('JSON loaded: $jsonString');
      Map<String, dynamic> data = json.decode(jsonString);
      print('Decoded data: $data');
      return data;
    } catch (e) {
      print('Error loading JSON: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Construyendo PageListOrder');
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Órdenes'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _orderDataFuture,
        builder: (context, snapshot) {
          print('Estado de FutureBuilder: ${snapshot.connectionState}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No hay datos disponibles'));
          }

          final data = snapshot.data!;
          final counters = data['counters'];
          final List<dynamic> ordersData = data['orders'];
          final orders =
              ordersData.map((json) => Order.fromJson(json)).toList();

          return Column(
            children: [
              _buildHeader(counters),
              Expanded(
                child: Container(
                    color: Colors.grey.withOpacity(0.1),
                    child: _buildOrderList(orders)),
              ),
              _buildRetireButton(),
            ],
          );
        },
      ),
    );
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

  Widget _buildCounter(String title, String count) {
    return Column(
      children: [
        Text(title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(count, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    return ListView.builder(
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

  Widget _buildRetireButton() {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50, // Altura fija del botón
              child: ComponentButtonCustom(
                text: 'Retirar pedidos',
                backgroundColor: colorScheme.primary,
                onPressed: () {
                  // Acción del botón
                  print("_goPageRetireProducts");
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
