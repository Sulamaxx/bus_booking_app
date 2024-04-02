import 'package:bus_booking_app/screens/auth/login_screen.dart';
import 'package:bus_booking_app/screens/main/bus_selection_screen.dart';
import 'package:bus_booking_app/screens/main/home_sceen.dart';
import 'package:bus_booking_app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:localstorage/localstorage.dart';

class BookingManagementScreen extends StatefulWidget {
  const BookingManagementScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BookingManagementScreenState();
}

class _BookingManagementScreenState extends State<BookingManagementScreen> {
  final LocalStorage storage = LocalStorage('user.json');
  final AuthService _authService = AuthService();
  late List<Map<String, dynamic>> bookedSeats = [];
  bool isLoading = false;
  Map<String, dynamic> userData = {};


  @override
  void initState() {
    super.initState();
    getBookedSeats();
  }

  Future<void> getBookedSeats() async {
    userData = storage.getItem('user');
    String uid = userData['uid'];
    print(uid);
    try {
      CollectionReference bookedSeatsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('booked_seats');

      QuerySnapshot querySnapshot = await bookedSeatsCollection.get();
      print("querySnapshot.docs");
      print(querySnapshot.docs);
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> seatData = {
          'id': doc.id,
          'routeId': doc['routeId'],
          'route_Id': doc['route_Id'],
          'busId': doc['busId'],
          'bus_Id': doc['bus_Id'],
          'busTime': doc['busTime'],
          'seatIds': List<String>.from(doc['seatIds']),
          'seatNumbers': List<int>.from(doc['seatNumbers']),
          'bookedDateTime': doc['bookedDateTime'].toDate(),
        };
        bookedSeats.add(seatData);
      });

      print('Booked seats: $bookedSeats');
      // Update the UI with the new data
      setState(() {});
    } catch (e) {
      print('Error getting booked seats: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sort the bookedSeats list by bookedDateTime
    bookedSeats
        .sort((a, b) => a['bookedDateTime'].compareTo(b['bookedDateTime']));
    bookedSeats = bookedSeats.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Management"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage(
                          'assets/logo_bus_booking_app.png',
                        ),
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        width: 300,
                        child: ElevatedButton(
                          onPressed: () {
                            _newBooking();
                          },
                          child: Text('New Booking'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (bookedSeats.isNotEmpty && bookedSeats.length > 0)
                        Container(
                          child: Column(
                            children: [
                              Text(
                                "Current Bookings",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 400,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      columnSpacing: 10,
                                      dataRowHeight: 50,
                                      border: TableBorder.all(
                                        color: Colors.red.withOpacity(0.3),
                                        width: 3,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: Text(
                                            'Ride Starting',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Route ID',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Bus ID',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Booked Date',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Seat Numbers',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Action',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: bookedSeats.map(
                                        (seat) {
                                          String timeString = seat['busTime'];
                                          DateTime now = DateTime.now();
                                          List<String> parts =
                                              timeString.split(':');
                                          int hour = int.parse(parts[0]);
                                          int minute = int.parse(parts[1]);
                                          DateTime timeStamp = DateTime(
                                              now.year,
                                              now.month,
                                              now.day,
                                              hour,
                                              minute);

                                          DateTime bookedDateTime =
                                              seat['bookedDateTime'];

                                          bool canCancel = timeStamp
                                                  .difference(bookedDateTime)
                                                  .inMinutes >=
                                              10;

                                          return DataRow(
                                            cells: [
                                              DataCell(
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: Text(
                                                      seat['busTime'],
                                                      style: canCancel
                                                          ? TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.green)
                                                          : TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: Text(
                                                      seat['routeId'],
                                                      style: canCancel
                                                          ? TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.green)
                                                          : TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: Text(
                                                      seat['busId'],
                                                      style: canCancel
                                                          ? TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.green)
                                                          : TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: Text(
                                                      '$bookedDateTime',
                                                      style: canCancel
                                                          ? TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.green)
                                                          : TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: Text(
                                                      seat['seatNumbers']
                                                          .toString(),
                                                      style: canCancel
                                                          ? TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.green)
                                                          : TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ElevatedButton(
                                                    onPressed: canCancel
                                                        ? () {
                                                            _cancelBooking(
                                                              seat['seatIds'],
                                                              seat['bus_Id'],
                                                              seat['route_Id'],
                                                              seat['id'],
                                                            );
                                                          }
                                                        : null,
                                                    child: Text('Cancel'),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (bookedSeats != null && bookedSeats.isEmpty)
                        Text('No bookings found'),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red[600])),
                        onPressed: () {
                          _logOut();
                        },
                        child: Text(
                          'LogOut',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void _newBooking() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => BusSelectionScreen()));
  }

  void _logOut() async {
    String? message = await _authService.signOut();

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

  void _cancelBooking(List<String> seatIds, String bus_Id, String route_Id,
      String bookedSeat) async {
    setState(() {
      isLoading = true;
    });
    String uid = userData['uid'];
    Color color = Colors.green;
    String message = "";
    try {
      for (String seat in seatIds) {
        await FirebaseFirestore.instance
            .collection('routes')
            .doc(route_Id)
            .collection('buses')
            .doc(bus_Id)
            .collection('seats')
            .doc(seat)
            .update({
          'availability': true,
          'booked_person': '',
        });
      }
      CollectionReference userCollection =
          FirebaseFirestore.instance.collection('users');

      await userCollection
          .doc(uid)
          .collection('booked_seats')
          .doc(bookedSeat)
          .delete();

      print('Seat deleted successfully');
      message = "Seats booked successfully.Check email for invoice";
    } catch (e) {
      print(e.toString());
      message = "Something went wrong try again later";
      color = Colors.red;
    }
    setState(() {
      isLoading = false;
    });
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        elevation: 8.0,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        content: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
