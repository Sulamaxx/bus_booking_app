import 'package:bus_booking_app/screens/main/payment_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

class BusSelectionScreen extends StatefulWidget {
  const BusSelectionScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BusSelectionScreenState();
}

class _BusSelectionScreenState extends State<BusSelectionScreen> {
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
            Expanded(
              child: ListView.builder(
                itemCount: 20, // Number of rows to generate
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('RowId'),
                            content: Text('Clicked on row with ID: $index'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('$index'),
                          Text('Name$index'),
                          Text('Profession$index'),
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
                paymentPage();
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

  // void seatselection(){
  //   Navigator.push(context,
  //   MaterialPageRoute(builder: (context)=>SeatSelectionScreen())
  //   );
  // }

  void paymentPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PaymentScreen()));
  }
}
