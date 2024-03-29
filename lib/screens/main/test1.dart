import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoutesAndBusesScreen extends StatefulWidget {
  @override
  _RoutesAndBusesScreenState createState() => _RoutesAndBusesScreenState();
}

class _RoutesAndBusesScreenState extends State<RoutesAndBusesScreen> {
  String? selectedRouteId; // Change to nullable
  List<DropdownMenuItem<String>> dropdownItems = [];
  List<Map<String, dynamic>> busesData = [];

  @override
  void initState() {
    super.initState();
    getRoutes();
  }

  Future<void> getRoutes() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('routes').get();

      setState(() {
        dropdownItems =
            querySnapshot.docs.map((DocumentSnapshot documentSnapshot) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          return DropdownMenuItem<String>(
            value: documentSnapshot.id,
            child: Text('${data['route']} - ${data['route_no']}'),
          );
        }).toList();
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getBusesForRoute(String? routeId) async {
    // Change to nullable
    if (routeId == null) return; // Added null check

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('routes')
          .doc(routeId)
          .collection('buses')
          .get();

      print(querySnapshot.docs);

      // for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      //   Map<String, dynamic> data =
      //       documentSnapshot.data() as Map<String, dynamic>;
      //   print('Bus ID: ${documentSnapshot.id}');
      //   print('Running Number: ${data['running_no']}');
      //   print('Time: ${data['time']}');
      // }
      setState(() {
        busesData = querySnapshot.docs.map((DocumentSnapshot documentSnapshot) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          return {
            'id': documentSnapshot.id,
            'runningNo': data['running_no'],
            'time': data['time'],
          };
        }).toList();
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              value: selectedRouteId,
              items: dropdownItems,
              onChanged: (String? value) {
                setState(() {
                  selectedRouteId = value;
                  getBusesForRoute(value);
                });
              },
              hint: Text('Select a route'),
            ),

            if (busesData.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: busesData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text('Bus ID: ${busesData[index]['id']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Running Number: ${busesData[index]['runningNo']}'),
                          Text('Time: ${busesData[index]['time']}'),
                        ],
                      ),
                    );
                  },
                ),
              ),

          ],
        ),
      ),
    );
  }
}
