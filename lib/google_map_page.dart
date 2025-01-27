import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map_integration/controller/fetch_stores_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapTask extends StatefulWidget {
  const GoogleMapTask({super.key});

  @override
  State<GoogleMapTask> createState() => _GoogleMapTaskState();
}

class _GoogleMapTaskState extends State<GoogleMapTask> {
  final googleMapTaskController = Get.put(GoogleMapTaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stores"),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Obx(() => GoogleMap(
                  onMapCreated: googleMapTaskController.onMapCreated,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(16.704, 74.243),
                    zoom: 13,
                  ),
                  markers: Set.from(googleMapTaskController.markerList),
                )),
          ),
          Expanded(
            child: Obx(() {
              if (googleMapTaskController.selectedStoresList.isEmpty) {
                return const Center(child: Text("Stores are not available"));
              }
              return ListView.builder(
                itemCount: googleMapTaskController.selectedStoresList.length,
                itemBuilder: (context, index) {
                  final store =
                      googleMapTaskController.selectedStoresList[index];
                  return GestureDetector(
                    onTap: () =>
                        googleMapTaskController.showMarkerAfterClick(store),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.orangeAccent),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.store,
                                color: Colors.orangeAccent,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        store['storeLocation'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        store['storeAddress'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Text(
                                '${store['distance']} km\nAway',
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Today: ${store['dayOfWeek']} ${store['start_time']} - ${store['end_time']}',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.orangeAccent,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Stores"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Cart"),
        ],
      ),
    );
  }
}
