import 'package:bus_booking_app/screens/main/payment_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SeatSelectionScreen extends StatefulWidget {
  final String busId;
  final String routeId;

  SeatSelectionScreen({required this.busId, required this.routeId});

  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  List<Map<String, dynamic>> seatsData = [];
  List<String> selectedSeats = [];
  List<int> selectedSeatsNo = [];

  @override
  void initState() {
    super.initState();
    print(widget.busId);
    print(widget.routeId);
    getSeatsByBus(widget.busId, widget.routeId);
  }

  Future<void> getSeatsByBus(String? busId, String? routeId) async {
    print("busId");
    print(busId);
    // Change to nullable
    if (busId == null) return; // Added null check

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('routes')
          .doc(routeId)
          .collection('buses')
          .doc(busId)
          .collection('seats')
          .get();

      print("querySnapshot.docs");
      print(querySnapshot.docs);

      setState(() {
        seatsData = querySnapshot.docs.map((DocumentSnapshot documentSnapshot) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          return {
            'id': documentSnapshot.id,
            'availability': data['availability'],
            'booked_person': data['booked_person'],
            'seat_no': data['seat_no'],
          };
        }).toList();
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sort the seatsData list by seat number
    seatsData.sort((a, b) => a['seat_no'].compareTo(b['seat_no']));
    return Scaffold(
      appBar: AppBar(
        title: Text('Seat Selection'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: seatsData.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic> seatData = seatsData[index];
                      bool isAvailable = seatData['availability'];
                      String? bookedPerson = seatData['booked_person'];
                      int seatNo = seatData['seat_no'];
                      String id = seatData['id'];

                      return SeatItem(
                        seatNo: seatNo,
                        isAvailable: isAvailable,
                        bookedPerson: bookedPerson,
                        id: id,
                        busId: widget.busId,
                        routeId: widget.routeId,
                        updateSeatSelection: (selected) {
                          setState(() {
                            if (selected) {
                              selectedSeats.add(id);
                              selectedSeatsNo.add(seatNo);
                            } else {
                              selectedSeats.remove(id);
                              selectedSeatsNo.remove(seatNo);
                            }
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Perform booking for selected seats
              print('Selected seats: $selectedSeats');
              print('Selected seatsNo: $selectedSeatsNo');
              // Implement your booking logic here
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaymentScreen(
                          selectedSeats: selectedSeats,
                          selectedSeatsNo: selectedSeatsNo,
                          busId: widget.busId,
                          routeId: widget.routeId)));
            },
            child: Text('Book Selected Seats'),
          ),
        ],
      ),
    );
  }
}

class SeatItem extends StatefulWidget {
  final int seatNo;
  final bool isAvailable;
  final String? bookedPerson;
  final String? id;
  final String busId;
  final String routeId;
  final Function(bool) updateSeatSelection;

  SeatItem({
    required this.seatNo,
    required this.isAvailable,
    this.bookedPerson,
    this.id,
    required this.busId,
    required this.routeId,
    required this.updateSeatSelection,
  });

  @override
  _SeatItemState createState() => _SeatItemState();
}

class _SeatItemState extends State<SeatItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    Color seatColor = isSelected
        ? Colors.blue
        : (widget.isAvailable ? Colors.green : Colors.red);
    IconData seatIcon = widget.isAvailable
        ? Icons.airline_seat_recline_extra
        : Icons.airline_seat_flat;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (widget.isAvailable) {
            setState(() {
              isSelected = !isSelected;
              widget.updateSeatSelection(isSelected);
            });
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: seatColor,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                seatIcon,
                color: Colors.white,
                size: 32.0,
              ),
              SizedBox(height: 4.0),
              Text(
                'Seat ${widget.seatNo}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!widget.isAvailable)
                Text(
                  'Booked: ${widget.bookedPerson}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
