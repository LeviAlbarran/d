import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cengodelivery/src/app.dart';
import 'package:cengodelivery/src/interfaces/order.dart';
import 'package:cengodelivery/src/pages/page_capture_photo.dart';
import 'package:cengodelivery/src/pages/page_map.dart';
import 'package:cengodelivery/src/providers/order_provider.dart';
import 'package:cengodelivery/src/widgets/component_button_custom.dart';
import 'package:cengodelivery/src/widgets/component_gallery_images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageRetireOrders extends StatelessWidget {
  final int orderIndex;

  const PageRetireOrders({super.key, required this.orderIndex});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    //final order = context.read<OrdersProvider>().getOrderByIndex(orderIndex);
    final orders = context.watch<OrderProvider>().orders;
    final order = orders[orderIndex];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.inverseSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Retirar pedido masivo',
            style: TextStyle(
                color: colorScheme.inverseSurface,
                fontSize: 18,
                fontWeight: FontWeight.w500)),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              order.pickupImages != null
                  ? _galleriaImagenes(context, order)
                  : _buildAdjuntarFotoCard(context, order),
              SizedBox(height: 10),
              _buildDetallePedidoCard(context, order),
              SizedBox(height: 10),
              _buildRetirarPedidoEnCard(context, order),
              SizedBox(height: 10),
              ComponentButtonCustom(
                  text: 'Retirar Pedido',
                  backgroundColor: colorScheme.primary,
                  onPressed: () {
                    print('test');
                    print(orders.length);
                    print(orderIndex + 1);
                    if (orders.length - 1 > (orderIndex)) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                PageRetireOrders(orderIndex: orderIndex + 1)),
                      );
                    } else {
                      print(
                          'volver'); /*
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => PageMap()),
                        (Route<dynamic> route) => false,
                      );*/

                      navigatorKey.currentState
                          ?.popUntil((route) => route.isFirst);
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  _goCaptureImage(context, order) async {
    print("cameras1");
    final cameras = await availableCameras();
    print("cameras");
    print(cameras);
    final firstCamera = cameras.reversed;

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PageCapturePhoto(orderId: order.id)));
  }

  Widget _galleriaImagenes(context, Order order) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final _order = orderProvider.orders.firstWhere((o) => o.id == order.id);
    List<File> _imagenes = [];
    if (order != null && order.pickupImages != null) {
      _imagenes = order.pickupImages!.map((path) => File(path)).toList();
    }
    print("_imagenes");
    print(_imagenes);
    return ImageGallery(
        order: order,
        onAddImage: () {
          _goCaptureImage(context, order);
        });
  }

  Widget _buildAdjuntarFotoCard(context, Order order) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[300]!, width: 0),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.image, size: 32, color: colorScheme.primary),
            ),
            SizedBox(height: 10),
            Text(
              'Adjuntar foto',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary),
            ),
            SizedBox(height: 8),
            Text(
              'Toma una o varias fotos del pedido como evidencia del retiro',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 10),
            ComponentButtonCustom(
                text: 'Tomar fotografía',
                backgroundColor: colorScheme.primary,
                onPressed: () async {
                  _goCaptureImage(context, order);
                })
          ],
        ),
      ),
    );
  }

  Widget _buildDetallePedidoCard(context, Order order) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[300]!, width: 0),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detalle del pedido',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary),
            ),
            SizedBox(height: 10),
            _buildDetailRow('N° pedido', order.orderNumber),
            _buildDetailRow('Productos', order.packages.toString()),
            _buildDetailRow('Unidades', order.packages.toString()),
            _buildDetailRow('Bultos', order.packages.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildRetirarPedidoEnCard(context, Order order) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[300]!, width: 0),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Retirar el pedido en',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.store, size: 24, color: colorScheme.primary),
              ),
              title: Text(
                'Nombre tienda',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Piso - Local 32',
                      style: TextStyle(fontSize: 15, color: Colors.grey[600])),
                  Text('Edificio / Mall',
                      style: TextStyle(fontSize: 15, color: Colors.grey[600])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
