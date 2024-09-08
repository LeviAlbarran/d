import 'package:cengodelivery/src/widgets/component_map_controller.dart';
import 'package:cengodelivery/src/widgets/component_map_controller_small.dart';
import 'package:flutter/material.dart';

class AnimatedMapController extends StatelessWidget {
  final bool isGoRoute;
  final VoidCallback zoomIncrease;
  final VoidCallback zoomDecrease;
  final VoidCallback onClear;
  final VoidCallback location;

  const AnimatedMapController({
    Key? key,
    required this.isGoRoute,
    required this.zoomIncrease,
    required this.zoomDecrease,
    required this.onClear,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      top: isGoRoute ? (MediaQuery.of(context).size.height / 2) - 120 : 90,
      right: MediaQuery.of(context).padding.right + 20.0,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: isGoRoute
            ? ComponentMapController(
                key: ValueKey('large'),
                zoomIncrease: zoomIncrease,
                zoomDecrease: zoomDecrease,
                onClear: onClear,
                location: location,
              )
            : ComponentMapControllerSmall(
                key: ValueKey('small'),
                zoomIncrease: zoomIncrease,
                zoomDecrease: zoomDecrease,
                onClear: onClear,
                location: location,
              ),
      ),
    );
  }
}
