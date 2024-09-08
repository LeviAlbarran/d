import 'package:cengodelivery/src/interfaces/order.dart';
import 'package:cengodelivery/src/providers/order_provider.dart';
import 'package:cengodelivery/src/widgets/component_button_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class PageCapturePhoto extends StatefulWidget {
  final int orderId;

  PageCapturePhoto({Key? key, required this.orderId}) : super(key: key);

  @override
  _PageCapturePhotoState createState() => _PageCapturePhotoState();
}

class _PageCapturePhotoState extends State<PageCapturePhoto> {
  static const int MAX_IMAGES = 5;
  List<File> _imagenes = [];
  late Future<void> _initializeControllerFuture;
  CameraController? _controller;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isTakingPicture = false;
  int _initializeAttempts = 0;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
    _cargarImagenesPrevias();
  }

  Future<void> _initializeCamera() async {
    if (_initializeAttempts >= 3) {
      throw Exception(
          'No se pudo inicializar la cámara después de múltiples intentos');
    }

    _initializeAttempts++;
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw CameraException(
            'No cameras found', 'No se encontraron cámaras disponibles');
      }
      _controller?.dispose();
      _controller = CameraController(cameras[0], ResolutionPreset.high);
      await _controller!.initialize();
      await _controller!.setFlashMode(FlashMode.auto);
      _initializeAttempts = 0;
    } catch (e) {
      print(
          'Error al inicializar la cámara (intento $_initializeAttempts): $e');
      if (_initializeAttempts < 3) {
        await Future.delayed(Duration(seconds: 1));
        return _initializeCamera();
      } else {
        rethrow;
      }
    }
  }

  Future<void> _tomarFoto() async {
    if (_isTakingPicture) return;
    if (_imagenes.length >= MAX_IMAGES) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Límite de 5 fotos alcanzado')),
      );
      return;
    }

    setState(() => _isTakingPicture = true);

    try {
      if (_controller == null || !_controller!.value.isInitialized) {
        throw CameraException(
            'Camera not initialized', 'La cámara no está inicializada');
      }

      HapticFeedback.mediumImpact();
      await _controller!.setFlashMode(FlashMode.auto);
      final XFile imageFile = await _controller!.takePicture();
      await _audioPlayer.play(AssetSource('sounds/camera_shutter.mp3'));

      final File optimizedImage = await _optimizeAndSaveImage(imageFile);
      setState(() => _imagenes.add(optimizedImage));
    } catch (e) {
      print('Error al tomar o procesar la foto: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al procesar la foto')),
      );
    } finally {
      setState(() => _isTakingPicture = false);
    }
  }

  Future<File> _optimizeAndSaveImage(XFile image) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = _generateFileName();
    final targetPath = '${directory.path}/$fileName';

    File originalFile = File(image.path);
    if (!await originalFile.exists()) {
      throw Exception('El archivo original no existe');
    }

    File compressedFile = await _compressImage(originalFile, targetPath);

    // Si el archivo comprimido sigue siendo demasiado grande, lo comprimimos más
    int maxSizeBytes = 1000000; // 1MB
    if (await compressedFile.length() > maxSizeBytes) {
      compressedFile =
          await _furtherCompressImage(compressedFile, maxSizeBytes);
    }

    return compressedFile;
  }

  Future<File> _compressImage(File file, String targetPath) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 88,
      minWidth: 1024,
      minHeight: 1024,
    );

    if (result == null) {
      throw Exception('La compresión de la imagen falló');
    }

    return File(result.path);
  }

  Future<File> _furtherCompressImage(File file, int maxSizeBytes) async {
    int quality = 80;
    File compressedFile = file;

    while (await compressedFile.length() > maxSizeBytes && quality > 50) {
      final tempPath = '${file.parent.path}/temp_${file.uri.pathSegments.last}';
      final result = await FlutterImageCompress.compressAndGetFile(
        compressedFile.absolute.path,
        tempPath,
        quality: quality,
        minWidth: 1024,
        minHeight: 1024,
      );

      if (result == null) {
        break; // Si la compresión falla, nos quedamos con la última versión exitosa
      }

      if (await File(tempPath).exists()) {
        await compressedFile.delete();
        compressedFile = File(result.path);
      }

      quality -= 5;
    }

    return compressedFile;
  }

  String _generateFileName() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyyMMdd_HHmmss');
    return '${widget.orderId}_${formatter.format(now)}.jpg';
  }

  Future<void> _reinicializarCamara() async {
    setState(() {
      _initializeControllerFuture = _initializeCamera();
    });
  }

  void _eliminarFoto(int index) {
    HapticFeedback.lightImpact();
    setState(() => _imagenes.removeAt(index));
  }

  void _actualizarProvider() {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final order =
        orderProvider.orders.firstWhere((o) => o.id == widget.orderId);

    List<String> imagePaths = _imagenes.map((file) => file.path).toList();

    Order updatedOrder = Order(
      id: order.id,
      orderNumber: order.orderNumber,
      address: order.address,
      client: order.client,
      timeWindow: order.timeWindow,
      status: order.status,
      latitude: order.latitude,
      longitude: order.longitude,
      packages: order.packages,
      isPrime: order.isPrime,
      hasFrozen: order.hasFrozen,
      hasCigarettes: order.hasCigarettes,
      hasAlcohol: order.hasAlcohol,
      pickupImages: imagePaths,
      deliveryImages: order.deliveryImages,
    );

    orderProvider.updateOrder(updatedOrder);
  }

  @override
  void dispose() {
    _controller?.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _cargarImagenesPrevias() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final order =
        orderProvider.orders.firstWhere((o) => o.id == widget.orderId);

    if (order.pickupImages != null) {
      setState(() {
        _imagenes = order.pickupImages!.map((path) => File(path)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      /*appBar: AppBar(
        title: Text('Retirar pedido'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),*/
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child:
                    Text('Error al inicializar la cámara: ${snapshot.error}'),
              );
            }
            return _buildCameraPreview(colorScheme);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
            padding: EdgeInsets.all(16.0),
            child: ComponentButtonCustom(
                text: 'Continuar',
                backgroundColor: colorScheme.primary,
                onPressed: () {
                  if (_imagenes.isNotEmpty) {
                    _actualizarProvider();
                    // Aquí puedes navegar a la siguiente pantalla o realizar otras acciones
                    Navigator.of(context).pop();
                  }
                })),
      ),
    );
  }

  Widget _buildCameraPreview(ColorScheme colorScheme) {
    return Stack(
      children: [
        Positioned.fill(
          child: AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: CameraPreview(_controller!),
          ),
        ),
        Positioned(
          top: 20,
          left: 20,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Evidencia adjunta: ${_imagenes.length}/$MAX_IMAGES Fotos',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width / 2 - 90 / 2,
            child: Container(
              height: 90,
              width: 90,
              child: GestureDetector(
                onTap: _isTakingPicture || _imagenes.length > MAX_IMAGES
                    ? null
                    : _tomarFoto,
                child: Container(
                  width: 90,
                  decoration: BoxDecoration(
                    color: _isTakingPicture
                        ? Colors.grey
                        : Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(1000),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                            0.2), // Sombra negra con algo de transparencia
                        spreadRadius: 2, // Cuán lejos se extiende la sombra
                        blurRadius: 10, // Cuánto se difumina la sombra
                        offset:
                            Offset(0, 5), // Desplazamiento de la sombra (x, y)
                      ),
                    ],
                  ),
                  child: Tooltip(
                    message: 'Tomar foto',
                    child: Icon(
                        _isTakingPicture
                            ? Icons.hourglass_empty
                            : Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 40),
                  ),
                ),
              ),
            )),
        Positioned(
          top: 70,
          left: 0,
          right: 0,
          child: Container(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:
                  _imagenes.length + (_imagenes.length < MAX_IMAGES ? 1 : 0),
              cacheExtent: 250,
              itemBuilder: (context, index) {
                if (index == 0 && _imagenes.length < MAX_IMAGES) {
                  return Padding(
                    padding: EdgeInsets.only(left: 10, right: 8),
                  );
                }
                final imageIndex =
                    _imagenes.length < MAX_IMAGES ? index - 1 : index;
                return Padding(
                  padding: EdgeInsets.only(right: 8, left: index == 0 ? 20 : 0),
                  child: Stack(
                    children: [
                      Container(
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: FileImage(_imagenes[imageIndex]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 4,
                        top: 4,
                        child: GestureDetector(
                          onTap: () => _eliminarFoto(imageIndex),
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: colorScheme.errorContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Tooltip(
                              message: 'Eliminar foto',
                              child: Icon(Icons.delete,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
