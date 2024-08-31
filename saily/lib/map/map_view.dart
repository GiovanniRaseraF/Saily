/*
author: Giovanni Rasera
*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/utils/hm_colors.dart';
import 'package:saily/widgets/gps_counter.dart';
import 'package:latlong2/latlong.dart';
import 'package:saily/utils/utils.dart';
import 'dart:async';

@pragma("vm:prefer-inline")
double deg2rad(double deg) {
  return deg / 180.0 * 3.14;
}

class MapView extends StatefulWidget {
  MapView({required this.settingsController});

  SettingsController settingsController;

  @override
  State<MapView> createState() =>
      MapViewState(settingsController: settingsController);
}

class MapViewState extends State<MapView> with TickerProviderStateMixin {
  MapViewState({required this.settingsController});

  SettingsController settingsController;

  late MapController _mapController;
  late TileProvider tileProvider;
  late InteractionOptions interactionOptions;
  late InteractionOptions defaultInteractionOptions;

  late StreamSubscription<double>? mapFakeOffsetStreamSub;

  double zoom = 16;
  double defaultFakeOffset = 0.00;
  double fakeOffset = 0;
  double boat_rotation = 0;
  double rotation = 0;

  late LatLng currentPosition;
  late LatLng fakeCurrentPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // offset
    settingsController.getCurrentMapFakeOffsetValue().then((value) {
      setFakeOffset(value);
    });

    _mapController = MapController();

    // interaction
    defaultInteractionOptions = const InteractionOptions(
      flags: InteractiveFlag.pinchZoom,
    );
    interactionOptions = defaultInteractionOptions;

    // positioning
    currentPosition = HuracanMarine().homePosition;
    fakeCurrentPosition = HuracanMarine().homePosition;

    // stream listener
    mapFakeOffsetStreamSub =
        settingsController.getCurrentMapFakeOffsetStream().listen((value) {
      setFakeOffset(value);
    });
  }

  @override
  void dispose() {
    super.dispose();

    // close stream
    if (mapFakeOffsetStreamSub != null) {
      mapFakeOffsetStreamSub!.cancel();
    }
  }

  static const _startedId = 'AnimatedMapController#MoveStarted';
  static const _inProgressId = 'AnimatedMapController#MoveInProgress';
  static const _finishedId = 'AnimatedMapController#MoveFinished';

  void setFakeOffset(double newV) {
    setState(() {
      fakeOffset = newV;
    });
  }

  void resetFakeOffset() {
    setState(() {
      fakeOffset = defaultFakeOffset;
    });
  }

  // move map
  void moveTo(LatLng to, double dest_rotation) {
    LatLng to_fake = LatLng(
        to.latitude - (fakeOffset / (_mapController.camera.zoom)),
        to.longitude);

    // just animation
    _animatedMapMove(to_fake, to, _mapController.camera.zoom, dest_rotation);

    fakeCurrentPosition = to_fake;
  }

  void _animatedMapMove(LatLng destLocation, LatLng fakedestLocation,
      double destZoom, double destRotation) {
    final camera = _mapController.camera;
    final latTween = Tween<double>(
        begin: fakeCurrentPosition.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: fakeCurrentPosition.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: camera.zoom, end: destZoom);

    final rotationTween = Tween<double>(begin: rotation, end: destRotation);
    final latPointerPosition = Tween<double>(
        begin: currentPosition.latitude, end: fakedestLocation.latitude);
    final lngPointerPosition = Tween<double>(
        begin: currentPosition.longitude, end: fakedestLocation.longitude);

    final controller = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);

    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    final startIdWithTarget =
        '$_startedId#${destLocation.latitude},${destLocation.longitude},$destZoom';
    bool hasTriggeredMove = false;

    controller.addListener(() {
      final String id;
      if (animation.value == 1.0) {
        id = _finishedId;
      } else if (!hasTriggeredMove) {
        id = startIdWithTarget;
      } else {
        id = _inProgressId;
      }

      currentPosition = LatLng(latPointerPosition.evaluate(animation),
          lngPointerPosition.evaluate(animation));
      rotation = rotationTween.evaluate(animation);

      _mapController.moveAndRotate(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
        rotation,
        id: id,
      );
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

  void followRotation(double rotation) {}

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        interactionOptions: interactionOptions,
        initialCenter: currentPosition,
        initialZoom: zoom,
        minZoom: 5,
        maxZoom: 16,
      ),
      children: [
        // actual map
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.huracan_marine',
          tileUpdateTransformer: _animatedMoveTileUpdateTransformer,
          tileProvider: CancellableNetworkTileProvider(),
        ),

        // will change using streams
        StreamBuilder<LatLng>(
            stream: settingsController.getCurrentBoatPositionStream(),
            builder: (bc, position) {
              var pos = fakeCurrentPosition;
              if (position.data != null) {
                pos = position.data!;
                currentPosition = pos;
              }

              // Move to new position
              moveTo(pos, 0);

              // create the marker
              return MarkerLayer(
                markers: [
                  Marker(
                      point: pos,
                      rotate: true,
                      width: 60,
                      height: 60,
                      child: Transform.rotate(
                        angle: deg2rad(rotation + 45),
                        child: Card(
                            elevation: 10,
                            color: Color.fromARGB(0, 255, 255, 255),
                            child: Icon(color: HMLightOrange, Icons.circle)),
                      ))
                ],
              );
            }),

      ],
    );
  }
}

final _animatedMoveTileUpdateTransformer =
    TileUpdateTransformer.fromHandlers(handleData: (updateEvent, sink) {
  final mapEvent = updateEvent.mapEvent;

  final id = mapEvent is MapEventMove ? mapEvent.id : null;
  if (id?.startsWith(MapViewState._startedId) == true) {
    final parts = id!.split('#')[2].split(',');
    final lat = double.parse(parts[0]);
    final lon = double.parse(parts[1]);
    final zoom = double.parse(parts[2]);

    sink.add(
      updateEvent.loadOnly(
        loadCenterOverride: LatLng(lat, lon),
        loadZoomOverride: zoom,
      ),
    );
  } else if (id == MapViewState._inProgressId) {
  } else if (id == MapViewState._finishedId) {
    sink.add(updateEvent.pruneOnly());
  } else {
    sink.add(updateEvent);
  }
});
