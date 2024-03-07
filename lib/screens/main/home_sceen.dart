import 'package:bus_booking_app/screens/main/bus_schedule_screen.dart';
import 'package:bus_booking_app/screens/main/booking_management_sceen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Image(
                    image: AssetImage(
                      'assets/logo_bus_booking_app.png',
                    ),
                    width: 300,
                    height: 300,
                  ),
                  const SizedBox(height: 40.0),
                  Container(
                    width: 300,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(vertical: 30, horizontal: 30)),
                      ),
                      onPressed: () {
                        _bookingManagement();
                      },
                      child: Text('Seat Booking Management'),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: 300,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(vertical: 30, horizontal: 30)),
                      ),
                      onPressed: () {
                        _busSchedule();
                      },
                      child: Text('Bus Schedule'),
                    ),
                  ),
                  const SizedBox(height: 100),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.red[600])),
                    onPressed: () {},
                    child: Text('LogOut'),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  void _bookingManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookingManagementScreen()),
    );
  }
  void _busSchedule() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BusScheduleScreen()),
    );
  }
}
