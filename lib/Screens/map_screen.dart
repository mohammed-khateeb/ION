import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:collection/collection.dart';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ion_application/Controller/auth_controller.dart';
import 'package:ion_application/Localization/language_constants.dart';
import 'package:ion_application/Utils/main_utils.dart';
import 'package:ion_application/Widgets/custom_inkwell.dart';
import 'package:ion_application/Widgets/gradient_card.dart';
import 'package:ion_application/Widgets/waiting_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../Components/Map_Component/charge_location.dart';
import '../Components/Map_Component/filter_types_component.dart';
import '../Models/Api/location.dart' as loc;
import '../Utils/mqtt_handler.dart';
import '../main.dart';


class MapScreen extends StatefulWidget {
  final bool allowBack;

  const MapScreen({
    Key? key,
    this.allowBack = false
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  Uint8List? pinIconBytes;
  final GlobalKey<FilterTypeComponentState> _filterKey = GlobalKey();

  final Completer<GoogleMapController> _controller = Completer();
  bool showTypes = false;
  List<loc.LocationModel> preLocations = [];
  loc.LocationModel? selectedLocation;
  Function eq = const ListEquality().equals;
  ValueNotifier<List<loc.LocationModel>> filteredLocations =
      ValueNotifier<List<loc.LocationModel>>([]);
  String? selectedType;
  List<GlobalKey> iconsKeys = [
  ];



  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(31.9594, 35.859),
    zoom: 12.0,
  );

  Uint8List? availableIcon;
  Uint8List? unavailableIcon;
  Uint8List? busyIcon;

  @override
  void dispose() {
    MainUtils.navKey.currentContext!.read<MqttHandler>().removeListener(() { });
    super.dispose();
  }

  @override
  void initState() {
    getIcons();
    if(MainUtils.navKey.currentContext!.read<AuthController>().userPosition==null) {
      MainUtils.navKey.currentContext!.read<AuthController>().addListener(() {
        if(MainUtils.navKey.currentContext!.read<AuthController>().userPosition!=null){
          moveCameraToUserLocation();
        }
      });
    }
    else{
      moveCameraToUserLocation();
    }
    context.read<MqttHandler>().addListener(() {
        setFilteredLocations();
    });

    super.initState();
  }

  getData(){
    setFilteredLocations();
  }





  getIcons() async {
    availableIcon = await getBytesFromAsset('assets/icons/available_location.png', 115);
    unavailableIcon = await getBytesFromAsset('assets/icons/unavailable_location.png', 115);
    busyIcon = await getBytesFromAsset('assets/icons/busy_location.png', 115);

    setState(() {});
    getData();

  }




  moveCameraToUserLocation() async {
    Position? userPosition = context.read<AuthController>().userPosition;
    final GoogleMapController controller = await _controller.future;
    if(userPosition!=null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        zoom: 12,
        target:
        LatLng(userPosition.latitude, userPosition.longitude))));
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          availableIcon == null || unavailableIcon == null || busyIcon == null
              ? const WaitingWidget()
              : ValueListenableBuilder<List<loc.LocationModel>>(
                  builder: (BuildContext context,
                      List<loc.LocationModel> value, Widget? child) {

                    return SizedBox(
                      height: size.height,
                      child: Stack(
                        children: [

                          Wrap(
                            children: value.map((e) {
                              return markerIcons(e);
                            }).toList(),
                          ),
                          Container(color: Colors.white,),///to remove marker under it
                          FutureBuilder<List<Marker>?>(
                              future: _getMarkers(value),
                              builder: (context, snapshot) {
                              return  GoogleMap(
                                myLocationEnabled: true,
                                myLocationButtonEnabled: false,

                                onTap: (latLng) {
                                  _filterKey.currentState!.collapseWidget();
                                  setState(() {
                                    selectedLocation = null;
                                  });
                                },
                                zoomControlsEnabled: false,
                                gestureRecognizers: {}..add(
                                    Factory<EagerGestureRecognizer>(
                                        () => EagerGestureRecognizer())),
                                mapType: MapType.normal,
                                initialCameraPosition: _kGooglePlex,

                                markers:!snapshot.hasData?<Marker>{}: snapshot.data!.isEmpty?<Marker>{}: snapshot.data!.toSet(),

                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                },
                              );
                            }
                          ),
                        ],
                      ),
                    );
                  },
                  valueListenable: filteredLocations,
                ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.06,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomInkwell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(size.height*0.01),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: size.height * 0.025,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        if(context.watch<AuthController>().userPosition!=null)
                        CustomInkwell(
                          onTap: (){
                            moveCameraToUserLocation();
                          },
                          child: GradientCard(
                            borderRadiusValue: size.height * 0.01,
                            child: SizedBox(
                              width: size.width * 0.18,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.01,
                                ),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "assets/icons/nearest_charger.png",
                                      height: size.height * 0.04,
                                    ),
                                    Text(
                                      getTranslated(context, "nearest_charger")!,
                                      style: TextStyle(
                                          fontSize: size.height * 0.013,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.015,
                        ),
                        // GradientCard(
                        //   borderRadiusValue: size.height * 0.01,
                        //   child: SizedBox(
                        //     width: size.width * 0.18,
                        //     child: Padding(
                        //       padding: EdgeInsets.symmetric(
                        //           vertical: size.height * 0.015,
                        //           horizontal: size.height * 0.005),
                        //       child: Column(
                        //         children: [
                        //           Image.asset(
                        //             "assets/icons/plan_trip.png",
                        //             height: size.height * 0.04,
                        //           ),
                        //           SizedBox(
                        //             height: size.height * 0.005,
                        //           ),
                        //           Text(
                        //             getTranslated(context, "plan_trip")!,
                        //             style: TextStyle(
                        //                 fontSize: size.height * 0.015,
                        //                 fontWeight: FontWeight.bold),
                        //             textAlign: TextAlign.center,
                        //           )
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: size.height * 0.015,
                        // ),
                        FilterTypeComponent(
                          key: _filterKey,
                          onSelectType: ({String? type}) {
                            filteredLocations.value = [];
                            selectedType = type;
                            getData();


                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],

          ),
          if (selectedLocation != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                  height: size.height * 0.28,
                  child: ChargeLocationComponent(
                    selectedLocation: selectedLocation!,
                  )),
            ),
        ],
      ),
    );
  }

  Future setFilteredLocations() async {
    if(!mounted)return;
    String json = context.read<MqttHandler>().data.value;
    if(!json.contains("latLng"))return;
    List<loc.LocationModel> locations = [];
    int index = 0;
    jsonDecode(json).forEach((v) async {
      loc.LocationModel singleLocation =
      loc.LocationModel.fromJson(v);
      singleLocation.index = index.toString();
      locations.add(singleLocation);
      iconsKeys.add(GlobalKey(debugLabel: singleLocation.index.toString()));
      index++;
    });

    locations.sort((a, b) => a.index!.compareTo(b.index!));

    iconsKeys.sort((a, b) => compareKeys(a, b));

    filteredLocations.value = selectedType == null
        ? locations
        : locations
            .where((element) =>
                (element.plugTypes!.toJson().contains(selectedType)))
            .toList();

  }

  int compareKeys(GlobalKey keyA, GlobalKey keyB) {

    // Extract the debug labels from the string representation
    final String debugLabelA = getIndexFromIconKey(keyA);
    final String debugLabelB = getIndexFromIconKey(keyB);

    // Sort the keys based on their debug labels
    return debugLabelA.compareTo(debugLabelB);
  }


  Future<BitmapDescriptor> getCustomIcon(GlobalKey iconKey) async {
    Future<Uint8List?> _capturePng(GlobalKey iconKey) async {
        final RenderRepaintBoundary boundary = iconKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;

          final ui.Image image = await boundary.toImage();
          ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
          var pngBytes = byteData?.buffer.asUint8List();
          return pngBytes;
    }

    Uint8List? imageData = await _capturePng(iconKey);
    return BitmapDescriptor.fromBytes(imageData!,);
  }

  Widget markerIcons(loc.LocationModel location){
    return location.startTime!=null?RepaintBoundary(
      key: iconsKeys.firstWhere((element) => getIndexFromIconKey(element) == location.index),
      child:
    Stack(
      children: [

        Image.asset(
          double.parse((59-DateTime.now().difference(location.startTime!).inMinutes).toStringAsFixed(0))<=0
              ?"assets/icons/unavailable_with_starttime_location.png"
              :"assets/icons/timer_location.png",
          height: 160,
          fit: BoxFit.cover,
        ),
        if(double.parse((60-DateTime.now().difference(location.startTime!).inMinutes).toStringAsFixed(0))/60>0
            &&double.parse((60-DateTime.now().difference(location.startTime!).inMinutes).toStringAsFixed(0))/60<=1)
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 60,
              right: 10
            ),
            child: SizedBox(
              height: 160,
              width: 160,

              child: CircularPercentIndicator(
                  radius: 35,
                  lineWidth: 5.0,
                  percent: double.parse((60-DateTime.now().difference(location.startTime!).inMinutes).toStringAsFixed(0))/60,
                  reverse: false,
                  center: Text(
                    (59-DateTime.now().difference(location.startTime!).inMinutes).toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  progressColor: Colors.grey[800],
                ),
            ),
          ),
        ),
      ],
    ),
    ):const SizedBox();
  }

  String getIndexFromIconKey(GlobalKey iconKey){
    return iconKey.toString().split(" ").last.split("]").first.toString();
  }



  Future<List<Marker>?> _getMarkers(List<loc.LocationModel> locations) async {
    final List<Marker> markers = [];

    for (var location in locations) {
      BitmapDescriptor? markerIcon;
      if(location.startTime!=null) {
          try{
            markerIcon = await getCustomIcon(iconsKeys.firstWhere((element) => getIndexFromIconKey(element) == location.index),);
          }catch(_){
            setState(() {});
          }

      }
      final marker = Marker(
        markerId: MarkerId(location.name!),
        position: LatLng(location.latLng!.latitude!,location.latLng!.longitude!),
          onTap: () {
            setState(() {
              _filterKey.currentState!.collapseWidget();

              if (selectedLocation == location) {
                selectedLocation = null;
              } else {
                selectedLocation = null;
                Future.delayed(const Duration(milliseconds: 200)).then((value){
                  selectedLocation = location;
                  setState(() {

                  });
                });
              }
            });
          },
        icon:location.startTime!=null&&markerIcon!=null?markerIcon: BitmapDescriptor.fromBytes(location.available==0&&location.total!>0?unavailableIcon!:location.available==0&&location.total==0?busyIcon!:availableIcon!),
      );

      markers.add(marker);
    }


    return markers;
  }
}
