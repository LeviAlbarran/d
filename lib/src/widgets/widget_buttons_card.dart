import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class WidgetButtonsCard extends StatefulWidget {
  final LatLng destination;

  const WidgetButtonsCard({Key? key, required this.destination})
      : super(key: key);

  @override
  _WidgetButtonsCardState createState() => _WidgetButtonsCardState();
}

class _WidgetButtonsCardState extends State<WidgetButtonsCard> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _launchMaps(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('No se pudo abrir $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: _isExpanded
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Image.asset('assets/images/googlemaps.png',
                        width: 24, height: 24),
                    onPressed: () {
                      final url =
                          'https://www.google.com/maps/search/?api=1&query=${widget.destination.latitude},${widget.destination.longitude}';
                      _launchMaps(url);
                    },
                  ),
                  IconButton(
                    icon: Image.asset('assets/images/waze.png',
                        width: 24, height: 24),
                    onPressed: () {
                      final url =
                          'https://waze.com/ul?ll=${widget.destination.latitude},${widget.destination.longitude}&navigate=yes';
                      _launchMaps(url);
                    },
                  ),
                ],
              )
            : Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: colorScheme.primary,
                            backgroundColor: colorScheme.surface,
                            side: BorderSide(
                                color: colorScheme.primary,
                                width: 2), // Añade un borde
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Ajusta el radio de las esquinas
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical:
                                    8), // Ajusta el padding si es necesario
                          ),
                          onPressed: _toggleExpand,
                          icon: const Icon(Icons.copy),
                          label: const Text('Copiar'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[100],
                            backgroundColor: colorScheme.primary,
                            side: BorderSide(
                                color: colorScheme.primary,
                                width: 2), // Añade un borde
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Ajusta el radio de las esquinas
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical:
                                    8), // Ajusta el padding si es necesario
                          ),
                          onPressed: _toggleExpand,
                          icon: const Icon(Icons.access_alarm),
                          label: const Text('Iniciar'),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
