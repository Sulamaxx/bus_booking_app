import 'package:bus_booking_app/screens/auth/login_screen.dart';
import 'package:bus_booking_app/screens/main/payment_screen.dart';
import 'package:bus_booking_app/screens/main/seat_selection_screen.dart';
import 'package:bus_booking_app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:localstorage/localstorage.dart';

class BusSelectionScreen extends StatefulWidget {
  const BusSelectionScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BusSelectionScreenState();
}

class _BusSelectionScreenState extends State<BusSelectionScreen> {
  final AuthService _authService = AuthService();
  final LocalStorage storage = LocalStorage('user.json');
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
    if (routeId == null) return;

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('routes')
          .doc(routeId)
          .collection('buses')
          .get();

      setState(() {
        busesData = querySnapshot.docs.map((DocumentSnapshot documentSnapshot) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          return {
            // 'route':routeId,
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
        title: Text("Bus Selection"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/logo_bus_booking_app.png'),
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20.0),
            Text(
              "Bus Schedule",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 10),
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
            Expanded(
              child: ListView.builder(
                itemCount: busesData.length, // Number of rows to generate
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _seatselection(index, selectedRouteId);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('$index'),
                          Text('${busesData[index]['runningNo']}'),
                          Text('${busesData[index]['time']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red[600]),
              ),
              onPressed: () {
                _logOut(context);
              },
              child: Text(
                'LogOut',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _seatselection(index, routeId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SeatSelectionScreen(
                  busId: busesData[index]['id'],
                  routeId: routeId,
                )));
  }

  void _logOut(context) async {
    String? message = await _authService.signOut();
    await storage.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        elevation: 8.0,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        content: Text(
          message!,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );

    if (message == "Logout Successfully!") {
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
      });
    }
  }

}


