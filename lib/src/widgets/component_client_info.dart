import 'package:flutter/material.dart';

class ComponentClientInfo extends StatelessWidget {
  final int number;
  final String order;
  final String client;
  final String phone;
  final String address;
  final bool isPrime;
  final int bags;
  final bool haveFrozen;

  const ComponentClientInfo({
    Key? key,
    required this.number,
    required this.order,
    required this.client,
    required this.phone,
    required this.address,
    required this.isPrime,
    required this.bags,
    required this.haveFrozen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return Container(
        padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
        decoration: BoxDecoration(
          //color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Expanded(
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[700],
                child: Text(
                  '$number',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: colorScheme.inverseSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: colorScheme.primary, // Color del borde
                                  width: 1, // Ancho del borde
                                ),
                                borderRadius: BorderRadius.circular(
                                    2), // Radio del borde circular
                              ),
                              child: Text(
                                'PRIME',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: colorScheme.primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Icon(Icons.ac_unit, color: colorScheme.primary),
                          ],
                        )
                      ],
                    ),
                    Text(
                      client,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[900], fontSize: 14),
                    ),
                    Text(
                      address,
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: Colors.grey[700], fontSize: 13),
                    ),
                  ],
                ),
              ),
              //Icon(Icons.phone, color: colorScheme.primary),
              /*        Stack(
                children: [
                  Icon(Icons.message_outlined, color: colorScheme.primary),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),*/
            ],
          ),
        ));
  }
}
