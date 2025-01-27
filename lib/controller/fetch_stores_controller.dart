import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleMapTaskController extends GetxController {
  GoogleMapController? googleMapController;
  var markerList = <Marker>[].obs;
  var selectedStoresList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchStores();
  }

  Future<void> fetchStores() async {
    const apiUrl = 'https://atomicbrain.neosao.online/nearest-store';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Map<String, dynamic>> stores =
            List<Map<String, dynamic>>.from(data['data'] ?? []);
        selectedStoresList.assignAll(stores);
      } else {
        throw Exception('Failed to load store data');
      }
    } catch (e) {
      Get.snackbar("Error", "Error fetching store data: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void showMarkerAfterClick(Map<String, dynamic> store) {
    googleMapController?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(
          double.parse(store['latitude']),
          double.parse(store['longitude']),
        ),
      ),
    );
    markerList.assignAll([
      Marker(
        markerId: MarkerId(store['code']),
        position: LatLng(
          double.parse(store['latitude']),
          double.parse(store['longitude']),
        ),
        infoWindow: InfoWindow(
          title: store['storeLocation'],
          snippet: store['storeAddress'],
        ),
      ),
    ]);
  }

  void onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
  }
}
