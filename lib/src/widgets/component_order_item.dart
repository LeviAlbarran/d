import 'package:cengodelivery/src/interfaces/order.dart';
import 'package:flutter/material.dart';

class ComponentOrderItem extends StatelessWidget {
  final Order order;

  const ComponentOrderItem({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(
          color: colorScheme.surface, // Color del borde
          width: 1, // Ancho del borde
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[600],
                  child: Text('${order.id}'),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.address,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Orden: ${order.orderNumber}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.more_vert),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                _buildInfoChip(Icons.access_time, order.timeWindow),
                SizedBox(width: 8),
                _buildInfoChip(Icons.circle, order.status, color: Colors.blue),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                _buildInfoChip(Icons.inventory, '${order.packages} bultos'),
                if (order.isPrime) ...[
                  SizedBox(width: 8),
                  _buildInfoChip(Icons.star, 'Prime', color: Colors.orange),
                ],
                if (order.hasFrozen) ...[
                  SizedBox(width: 8),
                  _buildInfoChip(Icons.ac_unit, 'Congelados',
                      color: Colors.blue),
                ],
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                if (order.hasCigarettes)
                  _buildInfoChip(Icons.smoking_rooms, 'Cigarros',
                      color: Colors.red),
                if (order.hasAlcohol) ...[
                  SizedBox(width: 8),
                  _buildInfoChip(Icons.local_bar, 'Alcohol',
                      color: Colors.purple),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label,
      {Color color = Colors.grey}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 14, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
