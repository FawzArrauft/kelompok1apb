import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late GoogleMapController _mapController;

  TextEditingController _latitudeController = TextEditingController();
  TextEditingController _longitudeController = TextEditingController();

  final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 10,
  );

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: _initialPosition,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _latitudeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Latitude',
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: _longitudeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Longitude',
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    double latitude =
                        double.tryParse(_latitudeController.text) ?? 0.0;
                    double longitude =
                        double.tryParse(_longitudeController.text) ?? 0.0;

                    LatLng newPosition = LatLng(latitude, longitude);

                    _mapController.animateCamera(
                      CameraUpdate.newLatLng(newPosition),
                    );
                  },
                  child: Text('Go'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
