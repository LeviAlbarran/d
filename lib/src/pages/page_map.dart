import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:cengodelivery/src/interfaces/Status.dart';
import 'package:cengodelivery/src/interfaces/order.dart';
import 'package:cengodelivery/src/pages/page_login.dart';
import 'package:cengodelivery/src/pages/page_profile.dart';
import 'package:cengodelivery/src/pages/page_retire_orders.dart';
import 'package:cengodelivery/src/providers/order_provider.dart';
import 'package:cengodelivery/src/providers/status_provider.dart';
import 'package:cengodelivery/src/widgets/component_active_user.dart';
import 'package:cengodelivery/src/widgets/component_animate_controller.dart';
import 'package:cengodelivery/src/widgets/component_list_order.dart';
import 'package:cengodelivery/src/widgets/component_loading.dart';
import 'package:cengodelivery/src/widgets/component_map_controller.dart';
import 'package:cengodelivery/src/widgets/component_map_controller_small.dart';
import 'package:cengodelivery/src/widgets/component_modal_assign_router.dart';
import 'package:cengodelivery/src/widgets/component_panel_routes.dart';
import 'package:cengodelivery/src/widgets/page_list_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import '../widgets/component_card_route.dart';

class PageMap extends StatefulWidget {
  const PageMap({Key? key}) : super(key: key);
  static const routeName = '/map';

  @override
  State<PageMap> createState() => _PageMapState();
}

class _PageMapState extends State<PageMap> with TickerProviderStateMixin {
  late LatLng myPoint;
  late LatLng myLocation;
  bool isLoading = true;
  List<LatLng> routePoints = [];
  List<Marker> markers = [];
  List<Marker> stores = [];
  final MapController mapController = MapController();
  int currentCardIndex = 0;
  List<ComponentRouteCard> routeCards = [];
  bool isActivate = false;
  //List<Order> orders = [];

  //var statusApp = Status(StatusType.start);
  //final status = Provider.of<StatusProvider>(context, listen: false).status; cuando solo es leer

  late ScrollController _scrollController = ScrollController(
      initialScrollOffset: MediaQuery.of(context).size.height * 0.8);

  @override
  void initState() {
    super.initState();
    myPoint = LatLng(-8.923303951223144, 13.182696707942991);

    _marketInit();
    _initPlatformState();
  }

  void _marketInit() {
    var latlng = LatLng(-33.4183167, -70.6059983);
    stores.add(
      Marker(
        point: latlng,
        width: 30,
        height: 30,
        child: Container(
          height: 30,
          width: 30,
          child: CircleAvatar(
            backgroundColor: Colors.black,
            child: Icon(
              Icons.store,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  bool _centerMapToGeolaction = true;
  Future<void> _initPlatformState() async {
    await bg.BackgroundGeolocation.ready(bg.Config(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        distanceFilter: 10.0,
        stopOnTerminate: false,
        startOnBoot: true,
        debug: true,
        logLevel: bg.Config.LOG_LEVEL_VERBOSE));

    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      print(
          "[onLocation] ${location.coords.latitude}, ${location.coords.longitude}");
      setState(() {
        myLocation =
            LatLng(location.coords.latitude, location.coords.longitude);
        isLoading = false;
      });

      if (_centerMapToGeolaction) {
        _animatedMapMove(myLocation, 16);
      }
      //_animatedMapMove(myLocation, 16);
    });

    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      print("[onMotionChange] ${location.isMoving}");
    });

    bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
      print("[onProviderChange] $event");
    });

    bg.BackgroundGeolocation.start();
  }

  Future<void> _getCoordinates(LatLng lat1, LatLng lat2) async {
    setState(() {
      isLoading = true;
    });

    final OpenRouteService client = OpenRouteService(
      apiKey: '5b3ce3597851110001cf624883f8e49ba9f1472f99537a543abd063c',
    );

    final List<ORSCoordinate> routeCoordinates =
        await client.directionsRouteCoordsGet(
      startCoordinate:
          ORSCoordinate(latitude: lat1.latitude, longitude: lat1.longitude),
      endCoordinate:
          ORSCoordinate(latitude: lat2.latitude, longitude: lat2.longitude),
    );

    final List<LatLng> routes = routeCoordinates
        .map((coordinate) => LatLng(coordinate.latitude, coordinate.longitude))
        .toList();

    setState(() {
      routePoints = routes;
      isLoading = false;
    });
  }

  List<Polyline> routePolylines = [];

  Future<void> _getCoordinatesAll(
      LatLng startPoint, List<LatLng> destinations) async {
    setState(() {
      isLoading = true;
    });

    final OpenRouteService client = OpenRouteService(
      apiKey: '5b3ce3597851110001cf624883f8e49ba9f1472f99537a543abd063c',
    );

    List<List<LatLng>> allRoutes = [];

    for (LatLng destination in destinations) {
      try {
        final List<ORSCoordinate> routeCoordinates =
            await client.directionsRouteCoordsGet(
          startCoordinate: ORSCoordinate(
              latitude: startPoint.latitude, longitude: startPoint.longitude),
          endCoordinate: ORSCoordinate(
              latitude: destination.latitude, longitude: destination.longitude),
          profileOverride: ORSProfile.drivingCar, // Use driving profile
        );

        final List<LatLng> route = routeCoordinates
            .map((coordinate) =>
                LatLng(coordinate.latitude, coordinate.longitude))
            .toList();

        allRoutes.add(route);
        routePolylines.add(Polyline(
          points: route,
          color: _getRandomColor(),
          isDotted: false,
          strokeWidth: 5.0,
        ));

        // Actualizar el punto de inicio para la próxima ruta
        startPoint = destination;
      } catch (e) {
        print('Error getting route: $e');
      }
    }

    setState(() {
      routePoints = allRoutes.expand((route) => route).toList();
      isLoading = false;
    });

    _fitMapToRoutes(allRoutes);
  }

  Color _getRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }

  void _fitMapToRoutes(List<List<LatLng>> routes) {
    if (routes.isEmpty) return;

    List<LatLng> allPoints = routes.expand((route) => route).toList();
    final bounds = LatLngBounds.fromPoints(allPoints);

    mapController.fitBounds(
      bounds,
      options: FitBoundsOptions(padding: EdgeInsets.all(50.0)),
    );
  }

  void _handleTap(LatLng latLng) {
    setState(() {
      if (markers.length < 3) {
        int markerNumber = markers.length + 1;
        markers.add(
          Marker(
            point: latLng,
            width: 30,
            height: 30,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[700],
              ),
              child: Center(
                child: Text(
                  markerNumber.toString(),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
        _updateRouteCards();
      }

      if (markers.length == 1) {
        _getCoordinates(myLocation, markers[0].point);
      }
    });
  }

  void _updateMapWithOrders() {
    List<LatLng> routesD = [];
    final orders = Provider.of<OrderProvider>(context, listen: false).orders;
    setState(() {
      markers.clear();
      routeCards.clear();

      for (int i = 0; i < orders.length; i++) {
        Order order = orders[i];
        LatLng point = LatLng(order.latitude, order.longitude);
        routesD.add(point);
        markers.add(
          Marker(
            point: point,
            width: 30,
            height: 30,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[700],
              ),
              child: Center(
                child: Text(
                  (i + 1).toString(),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );

        routeCards.add(
          ComponentRouteCard(
            number: i + 1,
            order: order.orderNumber,
            client: order
                .client, // You might want to add a client name to your Order class
            address: order.address,
            bags: order.packages,
            isPrime: order.isPrime,
            haveFrozen: order.hasFrozen,
            phone:
                '+56965631329', // You might want to add a phone number to your Order class
            coordinates: point,
            onTap: () => _centerMapOnPoint(point),
          ),
        );
        //_getCoordinatesAll(myLocation, routesD);
        if (orders.isNotEmpty) {
          setState(() {
            _centerMapToGeolaction = false;
          });
          _getCoordinatesAll(myLocation, routesD).then((_) {
            centerAndZoomToFitMarkers();
          });
        }
      }
    });

    if (orders.isNotEmpty) {
      centerAndZoomToFitMarkers();
      // _getRouteForOrders();
    }
  }

  void _updateRouteCards() {
    routeCards = markers.asMap().entries.map((entry) {
      int idx = entry.key;
      Marker marker = entry.value;
      return ComponentRouteCard(
        number: idx + 1,
        order: 'v139624532jmch-01',
        client: 'Juan Pablo Suazo',
        address: 'Avenida Tadeo Haenke 2221, 171 Torre A. Iquique',
        bags: 3,
        isPrime: true,
        haveFrozen: true,
        phone: '+56965631329',
        coordinates: marker.point,
        onTap: () => _centerMapOnPoint(marker.point),
      );
    }).toList();
  }

  void _centerMapOnPoint(LatLng point) {
    _animatedMapMove(point, 14);
    _getCoordinates(myLocation, point);
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  void _clearMap() {
    setState(() {
      markers = [];
      routePoints = [];
      routeCards = [];
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const PageProfile();
      },
    );
  }

  Future<void> _loadOrderData() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/data/orders_data.json');
      print('JSON cargado: $jsonString'); // Para depuración

      Map<String, dynamic> data = json.decode(jsonString);
      print('Datos decodificados: $data'); // Para depuración

      if (data['orders'] == null || (data['orders'] as List).isEmpty) {
        throw Exception('La lista de órdenes está vacía o es nula');
      }

      List<Order> loadedOrders =
          (data['orders'] as List).map((json) => Order.fromJson(json)).toList();

      // Usar el provider para actualizar las órdenes
      Provider.of<OrderProvider>(context, listen: false)
          .setOrders(loadedOrders);

      print(
          'Número de órdenes cargadas: ${loadedOrders.length}'); // Para depuración

      setState(() {
        isLoading = false;
      });

      _updateMapWithOrders();
    } catch (e) {
      print('Error cargando o procesando JSON: $e');
      setState(() {
        isLoading = false;
        var errorMessage =
            'No se pudieron cargar las órdenes. Por favor, inténtalo de nuevo.';
      });
    }
  }

  void centerAndZoomToFitMarkers() {
    if (markers.isEmpty && stores.isEmpty) return;

    // Collect all points from markers and stores
    List<LatLng> allPoints = [
      ...markers.map((marker) => marker.point),
      ...stores.map((store) => store.point),
    ];

    // If we have route points, include them as well
    if (routePoints.isNotEmpty) {
      allPoints.addAll(routePoints);
    }

    // Calculate the bounds
    double minLat = allPoints.map((p) => p.latitude).reduce(min);
    double maxLat = allPoints.map((p) => p.latitude).reduce(max);
    double minLong = allPoints.map((p) => p.longitude).reduce(min);
    double maxLong = allPoints.map((p) => p.longitude).reduce(max);

    // Create a LatLngBounds object
    LatLngBounds bounds = LatLngBounds(
      LatLng(minLat, minLong),
      LatLng(maxLat, maxLong),
    );

    // Use the mapController to move and zoom the map
    mapController.fitBounds(
      bounds,
      options: FitBoundsOptions(
        padding: EdgeInsets.all(50.0), // Add some padding around the bounds
      ),
    );
  }

  void _zoomIncrease() {
    mapController.move(mapController.center, mapController.zoom + 1);
  }

  void _zoomDecrease() {
    mapController.move(mapController.center, mapController.zoom - 1);
  }

  void _location() {
    if (myLocation != null) {
      _animatedMapMove(myLocation, 16);
    }
  }

  void _showRouteAssignedModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ComponenentModalRouteAssigned(
          onUnderstood: () {
            print("El usuario entendió la asignación de ruta");
            //statusApp.changeState(StatusType.acceptedRoute);
            Provider.of<StatusProvider>(context, listen: false)
                .setStatus(StatusType.acceptedRoute);

            _scrollController = ScrollController(
                initialScrollOffset: MediaQuery.of(context).size.height * 0.3);
            _loadOrderData();
          },
        );
      },
    );
  }

  void _onInitRouting(orders) {
    print("object");
    List<LatLng> routesD = [];
    Provider.of<StatusProvider>(context, listen: false)
        .setStatus(StatusType.goRoute);

    setState(() {
      markers.clear();
      routeCards.clear();

      for (int i = 0; i < orders.length; i++) {
        Order order = orders[i];
        LatLng point = LatLng(order.latitude, order.longitude);
        routesD.add(point);
        markers.add(
          Marker(
            point: point,
            width: 30,
            height: 30,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[700],
              ),
              child: Center(
                child: Text(
                  (i + 1).toString(),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );

        routeCards.add(
          ComponentRouteCard(
            number: i + 1,
            order: order.orderNumber,
            client: order
                .client, // You might want to add a client name to your Order class
            address: order.address,
            bags: order.packages,
            isPrime: order.isPrime,
            haveFrozen: order.hasFrozen,
            phone:
                '+56965631329', // You might want to add a phone number to your Order class
            coordinates: point,
            onTap: () => _centerMapOnPoint(point),
          ),
        );
        //_getCoordinatesAll(myLocation, routesD);

        setState(() {
          _centerMapToGeolaction = false;
        });
      }
    });
  }

  void _showAvailabilityModal(event) {
    print(event);
    setState(() {
      isActivate = event;
    });

    if (isActivate) {
      _showRouteAssignedModal();
    }
  }

  void _goPageRoute(BuildContext context) {
    // Aquí puedes agregar la lógica de validación de inicio de sesión
    // Por ahora, simplemente navegaremos a la pantalla de inicio
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => PageListOrder()),
    );
  }

  Widget _darkModeTileBuilder(
    BuildContext context,
    Widget tileWidget,
    TileImage tile,
  ) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        -0.2126, -0.7152, -0.0722, 0, 255, // Red channel
        -0.2126, -0.7152, -0.0722, 0, 255, // Green channel
        -0.2126, -0.7152, -0.0722, 0, 255, // Blue channel
        0, 0, 0, 1, 0, // Alpha channel
      ]),
      child: tileWidget,
    );
  }

  Widget _lightModeTileBuilder(
    BuildContext context,
    Widget tileWidget,
    TileImage tile,
  ) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ]),
      child: tileWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final orders = context.watch<OrderProvider>().orders;
    final statusApp = Provider.of<StatusProvider>(context);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: (statusApp.isGoRoute())
                ? MediaQuery.of(context).size.height
                : MediaQuery.of(context).size.height *
                    0.7, // 70% de la pantalla inicialmente
            collapsedHeight: (statusApp.isGoRoute())
                ? MediaQuery.of(context).size.height
                : MediaQuery.of(context).size.height *
                    0.3, // 30% de la pantalla cuando está colapsado

            floating: true,
            pinned: true,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final top = constraints.biggest.height;
                final expandedHeight = MediaQuery.of(context).size.height * 0.7;
                final collapsedHeight =
                    MediaQuery.of(context).size.height * 0.3;

                // Calculamos un factor de expansión entre 0 y 1
                final expandRatio = ((top - collapsedHeight) /
                        (expandedHeight - collapsedHeight))
                    .clamp(0.0, 1.0);

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        zoom: 16,
                        center: myPoint,
                        onTap: (tapPosition, latLng) => _handleTap(latLng),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          // tileBuilder: _lightModeTileBuilder,
                        ),
                        /*PolylineLayer(
                          polylines: [
                            Polyline(
                              points: routePoints,
                              color: Colors.blue,
                              strokeWidth: 4.0,
                            ),
                          ],
                        ),*/
                        PolylineLayer(
                          polylines: routePolylines,
                        ),
                        MarkerLayer(markers: markers),
                        MarkerLayer(markers: stores),
                      ],
                    ),
                    Visibility(
                      visible: isLoading,
                      child: ComponentLoading(),
                    ),
                    //Sección Superior

                    Positioned(
                        top: MediaQuery.of(context).padding.top + 10.0,
                        left: MediaQuery.of(context).padding.left + 20.0,
                        right: MediaQuery.of(context).padding.right + 20.0,
                        child: Container(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                              if (statusApp.isStart())
                                GestureDetector(
                                    onTap: () => _goPageRoute(context),
                                    child: ComponentPanelRoutes(
                                        colorScheme: colorScheme))
                              else
                                Container(),
                              GestureDetector(
                                onTap: () => _showModal(context),
                                child: const CircleAvatar(
                                  radius: 25,
                                  backgroundImage:
                                      AssetImage('assets/images/profile.png'),
                                ),
                              ),
                            ]))),

                    //Sección Derecha
                    AnimatedMapController(
                      isGoRoute: !statusApp.isAcceptedRoute(),
                      zoomIncrease: _zoomIncrease,
                      zoomDecrease: _zoomDecrease,
                      onClear: _clearMap,
                      location: _location,
                    ),

                    //Seccion Abajo
                    statusApp.isGoRoute()
                        ? Positioned(
                            bottom: 40,
                            left: 0,
                            right: 0,
                            child: SizedBox(
                              height: 180,
                              child: PageView.builder(
                                itemCount: routeCards.length,
                                controller:
                                    PageController(viewportFraction: 0.9),
                                onPageChanged: (index) {
                                  setState(() {
                                    currentCardIndex = index;
                                    _centerMapOnPoint(markers[index].point);
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return routeCards[index];
                                },
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                );
              },
            ),
          ),
          if (statusApp.isAcceptedRoute())
            SliverToBoxAdapter(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height *
                      0.3, // Mínimo 10% de la pantalla
                  maxHeight: MediaQuery.of(context).size.height *
                      0.7, // Máximo 80% de la pantalla
                ),
                child: ComponentListOrder(
                  orders: orders,
                  //counters: counters,
                  isEmbedded: true,
                  onInitRouting: () {
                    print("_onInitRouting");
                    _onInitRouting(orders);
                  },
                ),
              ),
            )
          else if (statusApp.isGoRoute())
            SliverToBoxAdapter(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 0, // Mínimo 10% de la pantalla
                  maxHeight: 0, // Máximo 80% de la pantalla
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return ComponentAvailabilityToggle(
                      onChange: _showAvailabilityModal,
                      isActivated: isActivate);
                },
                childCount: 1,
              ),
            ),
        ],
      ),
      /*floatingActionButton: ComponentMapController(
        zoomIncrease: _zoomIncrease,
        zoomDecrease: _zoomDecrease,
        onClear: _clearMap,
        location: _location,
      ),*/
    );
  }

  @override
  void dispose() {
    bg.BackgroundGeolocation.stop();
    super.dispose();
  }
}
