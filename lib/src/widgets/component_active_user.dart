import 'package:cengodelivery/src/widgets/component_modal_assign_router.dart';
import 'package:flutter/material.dart';

class ComponentAvailabilityToggle extends StatefulWidget {
  final Function onChange;
  final bool isActivated;

  const ComponentAvailabilityToggle(
      {Key? key, required this.onChange, required this.isActivated})
      : super(key: key);

  @override
  _ComponentAvailabilityToggleState createState() =>
      _ComponentAvailabilityToggleState();
}

class _ComponentAvailabilityToggleState
    extends State<ComponentAvailabilityToggle> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.isActivated ? 'Estás disponible' : 'No estás disponible',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Indica que estás disponible para que\npuedas recibir las rutas del día.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 5),
            Switch(
              value: widget.isActivated,
              onChanged: (value) {
                widget.onChange(value);
              },
              activeColor: Colors.blue,
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}
