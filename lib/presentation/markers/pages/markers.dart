import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/config/app_config.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/core/resources/route_arguments.dart';
import 'package:flutter_pet_shop_app/presentation/markers/cubit/markers_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/markers/cubit/markers_state.dart';
import 'package:flutter_pet_shop_app/presentation/markers/widgets/marker_info_window.dart';
import 'package:geolocator/geolocator.dart';
import 'package:platform_maps_flutter/platform_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';

class MarkersPage extends StatefulWidget {
  const MarkersPage({super.key});

  @override
  State<MarkersPage> createState() => _MarkersState();
}

class _MarkersState extends State<MarkersPage> {
  bool _isShowMarkerDetail = false;
  int _itemClickedIndex = -1;
  late PlatformMapController _mapController;
  @override
  Widget build(BuildContext context) {
    bool isShimmer = false;

    return SafeArea(
      bottom: false,
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          backgroundColor: AppColor.green,
          automaticallyImplyLeading: false,
          title: Text(
            'all_markers',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: AppColor.black),
          ).tr(),
          centerTitle: true,
        ),
        body: BlocProvider(
          create: (context) => MarkersCubit()..getAllMarkers(),
          child: BlocConsumer<MarkersCubit, MarkersState>(
            builder: (context, state) {
              return isShimmer || state.markerList.isEmpty
                  ? Shimmer.fromColors(
                      baseColor: AppColor.gray.withOpacity(0.4),
                      highlightColor: AppColor.white,
                      child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )
                  : Stack(
                      children: [
                        PlatformMap(
                            onMapCreated: (PlatformMapController controller) {
                              _mapController = controller;
                            },
                            initialCameraPosition: CameraPosition(
                              target: const LatLng(
                                  10.807302473390003, 106.66951777342513),
                              zoom: 16.0,
                            ),
                            myLocationButtonEnabled: true,
                            myLocationEnabled: true,
                            scrollGesturesEnabled: true,
                            rotateGesturesEnabled: false,
                            zoomControlsEnabled: false,
                            zoomGesturesEnabled: true,
                            compassEnabled: false,
                            gestureRecognizers: <Factory<
                                OneSequenceGestureRecognizer>>{
                              Factory<OneSequenceGestureRecognizer>(
                                () => EagerGestureRecognizer(),
                              )
                            },
                            markers: state.markerList.map((marker) {
                              return Marker(
                                  markerId: MarkerId(marker.id),
                                  position: marker.location,
                                  consumeTapEvents: true,
                                  infoWindow: InfoWindow.noText,
                                  onTap: () {
                                    setState(() {
                                      _isShowMarkerDetail = true;
                                      _itemClickedIndex =
                                          state.markerList.indexOf(marker);
                                    });
                                  });
                            }).toSet()),
                        Positioned(
                            bottom: AppConfig.mainBottomNavigationBarHeight * 2,
                            left: MediaQuery.of(context).size.width * 0.1,
                            right: MediaQuery.of(context).size.width * 0.1,
                            child: Visibility(
                                visible: _isShowMarkerDetail &&
                                    _itemClickedIndex >= 0,
                                child: _isShowMarkerDetail &&
                                        _itemClickedIndex >= 0
                                    ? MarkerInfoWindow(
                                        item:
                                            state.markerList[_itemClickedIndex],
                                        onCancelButtonClick: () {
                                          resetMarkerInfoWindow();
                                        },
                                        onViewDetailButtonClick: () {
                                          Navigator.of(context).pushNamed(
                                              RouteName.markerDetail,
                                              arguments:
                                                  MarkerDetailPageArguments(
                                                      markerId: state
                                                          .markerList[
                                                              _itemClickedIndex]
                                                          .id));
                                          resetMarkerInfoWindow();
                                        })
                                    : Container()))
                      ],
                    );
            },
            listener: (context, state) async {
              if (state.markerList.isNotEmpty) {
                setState(() {
                  isShimmer = false;
                });
              }
              Position currentLocation = await getCurrentLocation();

              _mapController.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      zoom: 14,
                      target: LatLng(currentLocation.latitude,
                          currentLocation.longitude))));
            },
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: AppConfig.mainBottomNavigationBarHeight,
        ),
      ),
    );
  }

  void resetMarkerInfoWindow() {
    setState(() {
      _isShowMarkerDetail = false;
      _itemClickedIndex = -1;
    });
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnable = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission;
    if (!serviceEnable) {
      return Future.error("Location services are disabled");
    }
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
