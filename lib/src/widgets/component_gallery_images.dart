import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:cengodelivery/src/providers/order_provider.dart';
import 'package:cengodelivery/src/interfaces/order.dart';

class ImageGallery extends StatefulWidget {
  final Order order;
  final Function() onAddImage;

  ImageGallery({Key? key, required this.order, required this.onAddImage})
      : super(key: key);

  @override
  _ImageGalleryState createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final _order =
        orderProvider.orders.firstWhere((o) => o.id == widget.order.id);
    List<File> _imagenes = [];
    if (_order.pickupImages != null) {
      _imagenes = _order.pickupImages!.map((path) => File(path)).toList();
    }

    return Column(
      children: [
        // Imagen principal
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              /*boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                )
              ],,*/
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _imagenes.isEmpty
                  ? Center(child: Text('No hay imágenes'))
                  : PageView.builder(
                      controller: _pageController,
                      itemCount: _imagenes.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.file(
                          _imagenes[index],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
            ),
          ),
        ),
        // Indicadores de página
        if (_imagenes.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _imagenes.asMap().entries.map((entry) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade400,
                ),
              );
            }).toList(),
          ),
        // Miniaturas y botón de añadir
        Container(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _imagenes.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: EdgeInsets.only(left: 8, right: 4),
                  child: GestureDetector(
                    onTap: widget.onAddImage,
                    child: Container(
                      width: 70,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.camera_alt_outlined,
                          color: colorScheme.primary),
                    ),
                  ),
                );
              }
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index - 1,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  width: 70,
                  height: 70,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _currentIndex == index - 1
                          ? Colors.blue
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.file(
                      _imagenes[index - 1],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
