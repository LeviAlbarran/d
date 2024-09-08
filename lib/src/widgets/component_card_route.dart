import 'package:cengodelivery/src/widgets/component_client_info.dart';
import 'package:cengodelivery/src/widgets/widget_buttons_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:latlong2/latlong.dart';

class ComponentRouteCard extends StatelessWidget {
  final int number;
  final String order;
  final String client;
  final String address;
  final bool isPrime;
  final int bags;
  final bool haveFrozen;
  final String phone;
  final LatLng coordinates;
  final VoidCallback onTap;

  const ComponentRouteCard(
      {Key? key,
      required this.number,
      required this.coordinates,
      required this.onTap,
      required this.order,
      required this.bags,
      required this.client,
      required this.address,
      required this.isPrime,
      required this.haveFrozen,
      required this.phone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: SafeArea(
        child: Container(
          width: 380,
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                ComponentClientInfo(
                  number: number,
                  order: order,
                  client: client,
                  address: address,
                  bags: bags,
                  isPrime: isPrime,
                  haveFrozen: haveFrozen,
                  phone: phone,
                ),
                WidgetButtonsCard(destination: coordinates),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
