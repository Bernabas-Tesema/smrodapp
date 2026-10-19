import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../geofence/domain/entities/geofence.dart';
import '../../domain/entities/vehicle_location.dart';

/// Vehicle map widget.
class VehicleMap extends StatefulWidget {
  const VehicleMap({
    super.key,
    required this.current,
    required this.history,
    required this.zones,
    this.immobilized = false,
  });

  final VehicleLocation? current;
  final List<VehicleLocation> history;
  final List<Geofence> zones;
  final bool immobilized;

  @override
  State<VehicleMap> createState() => _VehicleMapState();
}

class _VehicleMapState extends State<VehicleMap> {
  final MapController _controller = MapController();

  @override
  void didUpdateWidget(VehicleMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    final current = widget.current;
    final previous = oldWidget.current;
    if (current == null || previous == null) return;
    final moved = (current.latitude - previous.latitude).abs() > 0.00001 ||
        (current.longitude - previous.longitude).abs() > 0.00001;
    if (!moved) return;
    final point = LatLng(current.latitude, current.longitude);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        _controller.move(point, _controller.camera.zoom);
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    final current = widget.current;
    final point = current == null
        ? const LatLng(9.03, 38.74)
        : LatLng(current.latitude, current.longitude);
    final trail = widget.history.map((item) => LatLng(item.latitude, item.longitude)).toList();

    return FlutterMap(
      mapController: _controller,
      options: MapOptions(initialCenter: point, initialZoom: 14),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.smrod.vehicle',
        ),
        CircleLayer(
          circles: [
            for (final zone in widget.zones)
              if (zone.active)
                CircleMarker(
                  point: LatLng(zone.centerLat, zone.centerLng),
                  radius: zone.radiusMeters,
                  useRadiusInMeter: true,
                  color: AppColors.green.withValues(alpha: 0.16),
                  borderColor: AppColors.green,
                  borderStrokeWidth: 2,
                ),
          ],
        ),
        if (trail.length > 1)
          PolylineLayer(
            polylines: [
              Polyline(points: trail, strokeWidth: 4, color: AppColors.red),
            ],
          ),
        MarkerLayer(
          markers: [
            Marker(
              point: point,
              width: 44,
              height: 44,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: widget.immobilized ? AppColors.green : AppColors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Icon(
                  widget.immobilized ? Icons.lock : Icons.directions_car_filled,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
