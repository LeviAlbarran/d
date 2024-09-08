import 'package:cengodelivery/src/widgets/component_button_custom.dart';
import 'package:flutter/material.dart';

class ComponenentModalRouteAssigned extends StatelessWidget {
  final VoidCallback onUnderstood;

  const ComponenentModalRouteAssigned({Key? key, required this.onUnderstood})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: contentBox(context),
      ),
    );
  }

  Widget contentBox(context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(
              Icons.local_shipping_outlined,
              size: 30,
              color: colorScheme.primary,
            ),
          ),
          SizedBox(height: 15),
          Text(
            "Ruta asignada",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary),
          ),
          SizedBox(height: 15),
          Text(
            "Tienes una nueva ruta asignada.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Container(
            width: 300,
            child: ComponentButtonCustom(
              backgroundColor: colorScheme.primary,
              textColor: Colors.white,
              text: "Entendido",
              onPressed: () {
                Navigator.of(context).pop();
                onUnderstood();
              },
            ),
          ),
        ],
      ),
    );
  }
}
