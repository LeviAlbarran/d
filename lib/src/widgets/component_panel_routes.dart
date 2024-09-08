import 'package:flutter/material.dart';

class ComponentPanelRoutes extends StatelessWidget {
  const ComponentPanelRoutes({
    super.key,
    required this.colorScheme,
  });

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => _goPageRoute(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              height: 30,
              width: 30,
              child: CircleAvatar(
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.store,
                  size: 18,
                  color: colorScheme.surface,
                ),
              ),
            ),
            Text(
              'J510 - Darkstore Costanera -5',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
