import 'package:flutter/material.dart';
class SeatSelectionScreen extends StatefulWidget {
  final int seatsNeeded;
  SeatSelectionScreen({required this.seatsNeeded});
  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}
class Seat {
  var seatNumber;
  var gender;
  var available;
  Seat(this.seatNumber, this.gender, this.available);
  Seat.available(this.seatNumber, this.available);
  void changeAvailability() {
    available = !available;
  }
}
class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  List<Seat> seats = [
    Seat(1, null, true),
    Seat(2, null, true),
    Seat(3, 'M', false),
    Seat(4, null, true),
    Seat(5, null, true),
    Seat(6, null, true),
    Seat(7, 'F', false),
    Seat(8, 'M', false),
    Seat(9, null, true),
    Seat(10, null, true),
    Seat(11, null, true),
    Seat(12, null, true),
    Seat(13, null, true),
    Seat(14, null, true),
    Seat(15, 'M', false),
    Seat(16, 'F', false),
    Seat(17, 'F', false),
    Seat(18, 'F', false),
    Seat(19, 'M', false),
    Seat(20, null, true),
    Seat(21, null, true),
    Seat(22, null, true),
    Seat(23, null, true),
    Seat(24, null, true),
    Seat(25, null, true),
    Seat(26, null, true),
    Seat(27, null, true),
    Seat(28, null, true),
    Seat(29, null, true),
    Seat(30, null, true),
    Seat(31, null, true),
    Seat(32, null, true),
    Seat(33, null, true),
    Seat(34, null, true),
    Seat(35, null, true),
    Seat(36, null, true),
    Seat(37, null, true),
    Seat(38, null, true),
    Seat(39, null, true),
    Seat(40, null, true),
    Seat(41, null, true),
    Seat(42, null, true),
    Seat(43, null, true),
    Seat(44, null, true),
    Seat(45, null, true),
  ];
  List<Seat> selectedSeats = [];
  void _toggleSeatSelection(Seat seat) {
    if (selectedSeats.contains(seat)) {
      setState(() {
        selectedSeats.remove(seat);
        seat.changeAvailability();
      });
    } else {
      setState(() {
        if (selectedSeats.length < widget.seatsNeeded && seat.available) {
          selectedSeats.add(seat);
          seat.changeAvailability();
        }
      });
    }
  }
  bool _isSeatSelected(Seat seat) {
    return selectedSeats.contains(seat);
  }
  @override
  Widget build(BuildContext context) {
    // Calculate total rows and columns
    int totalRows = 11;
    int totalColumns = 4; // 2 seats aisle 2 seats configuration for first 10 rows
    // Create seat layout
    List<Widget> seatRows = [];
    for (int i = 0; i < totalRows - 1; i++) {
      // Add 2 seats aisle 2 seats configuration for first 10 rows
      seatRows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(totalColumns, (index) {
          int seatNumber = i * totalColumns + index + 1;
          Seat seat = seats.firstWhere((seat) => seat.seatNumber == seatNumber,
              orElse: () => Seat(-1, '', false));
          return GestureDetector(
            onTap: () => _toggleSeatSelection(seat),
            child: Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: seat.available
                    ? (_isSeatSelected(seat) ? Colors.blue : Colors.green)
                    : Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Stack(
                  children: [
                    Text(
                      seat.seatNumber.toString(),
                      style: TextStyle(
                        color: seat.available
                            ? (_isSeatSelected(seat)
                            ? Colors.white
                            : Colors.white)
                            : Colors.black,
                      ),
                    ),
                    if (!seat.available && seat.gender != null)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Icon(
                          seat.gender == 'M'
                              ? Icons.male
                              : Icons.female,
                          color: Colors.white,
                          size: 16,
                        ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ));
    }
    // Add last row with 5 seats
    seatRows.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        int seatNumber = (totalRows - 1) * totalColumns + index + 1;
        Seat seat = seats.firstWhere((seat) => seat.seatNumber == seatNumber,
            orElse: () => Seat(-1, '', false));
        return GestureDetector(
          onTap: () => _toggleSeatSelection(seat),
          child: Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: seat.available
                  ? (_isSeatSelected(seat) ? Colors.blue : Colors.green)
                  : Colors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                seat.seatNumber.toString(),
                style: TextStyle(
                  color: seat.available
                      ? (_isSeatSelected(seat) ? Colors.white : Colors.white)
                      : Colors.black,
                ),
              ),
            ),
          ),
        );
      }),
    ));
    return Scaffold(
      appBar: AppBar(
        title: Text('Seat Selection'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: seatRows,
        ),
      ),
    );
  }
}
