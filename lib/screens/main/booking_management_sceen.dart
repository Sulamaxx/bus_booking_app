import 'package:bus_booking_app/screens/main/bus_selection_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

class BookingManagementScreen extends StatefulWidget {
  const BookingManagementScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BookingManagementScreenState();
}

class _BookingManagementScreenState extends State<BookingManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Management"),
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
                            child: DataTable(
                              columnSpacing: 10,
                              dataRowHeight: 50,
                              columns: [
                                DataColumn(
                                  label: Text(
                                    'ID',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Name',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Profession',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                              rows: List.generate(
                                20, // Number of rows to generate
                                (index) => DataRow(cells: [
                                  DataCell(Text('$index')),
                                  DataCell(Text('Name$index')),
                                  DataCell(Text('Profession$index')),
                                ]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.red[600])),
                    onPressed: () {

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
    );
  }

  void _newBooking(){
    Navigator.push(context,
    MaterialPageRoute(builder: (context)=>BusSelectionScreen())
    );
  }

}
