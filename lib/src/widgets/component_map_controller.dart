import 'package:flutter/material.dart';

class ComponentMapController extends StatelessWidget {
  final VoidCallback zoomIncrease;
  final VoidCallback zoomDecrease;
  final VoidCallback onClear;
  final VoidCallback location;

  const ComponentMapController({
    super.key,
    required this.zoomIncrease,
    required this.zoomDecrease,
    required this.onClear,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /*         const SizedBox(height: 7),
          Container(
            width: 50, // Establece el tamaño personalizado
            height: 50,

            child: FloatingActionButton(
              backgroundColor: colorScheme.primary,
              child: Icon(Icons.clear_sharp),
              onPressed: onClear,
            ),
          ),*/
          const SizedBox(height: 7),
          Container(
            width: 50, // Establece el tamaño personalizado
            height: 50,

            child: FloatingActionButton(
              backgroundColor: Colors.grey[900],
              onPressed: zoomIncrease,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 7),
          Container(
            width: 50, // Establece el tamaño personalizado
            height: 50,
            child: FloatingActionButton(
              backgroundColor: Colors.grey[900],
              onPressed: zoomDecrease,
              child: const Icon(
                Icons.remove,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 7),
          Container(
            width: 50,
            height: 50,
            child: FloatingActionButton(
              backgroundColor: colorScheme.primary,
              child: Icon(Icons.my_location),
              onPressed: location,
            ),
          ),
        ],
      ),
    );
  }
}
