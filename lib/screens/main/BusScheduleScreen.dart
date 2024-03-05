import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusScheduleScreen extends StatefulWidget {
  const BusScheduleScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BusScheduleScreenState();
}

class _BusScheduleScreenState extends State<BusScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bus Schedule"),
      ),
      body: SingleChildScrollView(
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
                    width: 300,
                    height: 300,
                  ),
                  const SizedBox(height: 40.0),
                  // Container(
                  //   width: 300,
                  //   child: ElevatedButton(
                  //     style: ButtonStyle(
                  //       padding: MaterialStateProperty.all(
                  //           EdgeInsets.symmetric(vertical: 30, horizontal: 30)),
                  //     ),
                  //     onPressed: () {},
                  //     child: Text('Seat Booking Management'),
                  //   ),
                  // ),
                  // const SizedBox(height: 40),
                  // Container(
                  //   width: 300,
                  //   child: ElevatedButton(
                  //     style: ButtonStyle(
                  //       padding: MaterialStateProperty.all(
                  //           EdgeInsets.symmetric(vertical: 30, horizontal: 30)),
                  //     ),
                  //     onPressed: () {},
                  //     child: Text('Bus Schedule'),
                  //   ),
                  // ),
                  // const SizedBox(height: 100),
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
}
