import 'dart:convert';

import 'package:bus_booking_app/models/user.dart';
import 'package:bus_booking_app/screens/auth/login_screen.dart';
import 'package:bus_booking_app/screens/main/bus_schedule_screen.dart';
import 'package:bus_booking_app/screens/main/booking_management_sceen.dart';
import 'package:bus_booking_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final LocalStorage storage = LocalStorage('user.json');

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      child: Scaffold(
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
                              EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 30)),
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
                              EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 30)),
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
              )),
        ),
      ),
      onWillPop: () async {
        // Disable back navigation
        return false;
      },
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
