import 'dart:convert';
import 'dart:io';
import 'package:bus_booking_app/screens/auth/signup_screen.dart';
import 'package:bus_booking_app/screens/main/home_sceen.dart';
import 'package:bus_booking_app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:mailer/mailer.dart' as mailer;

class PaymentScreen extends StatefulWidget {
  final List<String> selectedSeats;
  final List<int> selectedSeatsNo;
  final String busId;
  final String routeId;

  const PaymentScreen({
    Key? key,
    required this.selectedSeats,
    required this.selectedSeatsNo,
    required this.busId,
    required this.routeId,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final LocalStorage storage = LocalStorage('user.json');
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool isLoading = false;
  int seatCountPaymentChild = 0;
  int seatCountPaymentElder = 0;
  double childPayment = 5.00;
  double elderPayment = 10.00;
  double childPaymentTotal = 0.00;
  double elderPaymentTotal = 0.00;
  double totalPayment = 0.00;

  late dynamic busData = {};
  late dynamic routeData = {};
  late dynamic userDataDatabase = {};

  @override
  void initState() {
    super.initState();
    getRoute(widget.routeId);
    getBus(widget.routeId, widget.busId);
    setupNotifications();
  }

  // Future<void> setupNotifications() async {
  //   // Request permissions for iOS
  //   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('@mipmap/ic_launcher');
  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(android: initializationSettingsAndroid);
  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  //
  //   final settings = InitializationSettings(
  //     iOS: IOSInitializationSettings(
  //         requestSoundPermission: true,
  //         requestBadgePermission: true,
  //         requestAlertPermission: true,
  //         onDidReceiveLocalNotification:
  //             (int id, String? title, String? body, String? payload) async {
  //           showDialog(
  //             context: context,
  //             builder: (_) => AlertDialog(
  //               title: Text(title ?? ''),
  //               content: Text(body ?? ''),
  //               actions: [
  //                 TextButton(
  //                   onPressed: () => Navigator.pop(context),
  //                   child: Text('OK'),
  //                 ),
  //               ],
  //             ),
  //           );
  //         }),
  //     android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  //   );
  //   await flutterLocalNotificationsPlugin.initialize(settings);
  //
  //   // Schedule notifications
  //   await scheduleNotification(20, '20 minutes before departure');
  //   await scheduleNotification(10, '10 minutes before departure');
  // }

  Future<void> setupNotifications() async {
    // Initialize flutterLocalNotificationsPlugin
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Request permissions for iOS
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    final settings = InitializationSettings(
      iOS: IOSInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
          onDidReceiveLocalNotification:
              (int id, String? title, String? body, String? payload) async {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(title ?? ''),
                content: Text(body ?? ''),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          }),
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await flutterLocalNotificationsPlugin.initialize(settings);

    // Schedule notifications
    await scheduleNotification(20, '20 minutes before departure');
    await scheduleNotification(10, '10 minutes before departure');
  }



  Future<void> scheduleNotification(int minutesBefore, String message) async {
    DateTime now = DateTime.now();
    String? timeString = busData['time'];
    if (timeString != null) {
      List<String> parts = timeString.split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      DateTime timeStamp = DateTime(now.year, now.month, now.day, hour, minute);
      DateTime notificationTime =
          timeStamp.subtract(Duration(minutes: minutesBefore));

      // Convert DateTime to TZDateTime
      tz.TZDateTime scheduledTime =
          tz.TZDateTime.from(notificationTime, tz.local);

      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Go Bus Now',
        message,
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'your channel id', 'your channel name'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } else {
      print('Bus time is null');
    }
  }

  Future<void> getUser(String? userId) async {
    if (userId == null) return;

    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          userDataDatabase = {
            'id': documentSnapshot.id,
            'email': data['email'],
            'gender': data['gender'],
            'mobile': data['mobile'],
            'nicPassport': data['nicPassport'],
            'gender': data['gender'],
          };
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getRoute(String? routeId) async {
    if (routeId == null) return;

    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('routes')
          .doc(routeId)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          routeData = {
            'id': documentSnapshot.id,
            'route': data['route'],
            'route_no': data['route_no'],
            'distance': data['distance'],
          };
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getBus(String? routeId, String? busId) async {
    if (routeId == null || busId == null) return;

    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('routes')
          .doc(routeId)
          .collection('buses')
          .doc(busId)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          busData = {
            'id': documentSnapshot.id,
            'runningNo': data['running_no'],
            'time': data['time'],
          };
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Page"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage(
                        'assets/logo_bus_booking_app.png',
                      ),
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(height: 25.0),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          "Seat Count :",
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 22,
                            fontFamily: "Raleway",
                            fontWeight: FontWeight.w700,
                          ),
                        )),
                        Expanded(
                            child: Text(
                          "${widget.selectedSeats.length}",
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 22,
                            fontFamily: "Raleway",
                            fontWeight: FontWeight.w700,
                          ),
                        ))
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          "Route :",
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 22,
                            fontFamily: "Raleway",
                            fontWeight: FontWeight.w700,
                          ),
                        )),
                        Expanded(
                            child: Text(
                          "${routeData['route']} - ${routeData['route_no']}",
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 22,
                            fontFamily: "Raleway",
                            fontWeight: FontWeight.w700,
                          ),
                        ))
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          "Bus :",
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 22,
                            fontFamily: "Raleway",
                            fontWeight: FontWeight.w700,
                          ),
                        )),
                        Expanded(
                            child: Text(
                          "${busData != null ? busData['runningNo'] : ''}",
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 22,
                            fontFamily: "Raleway",
                            fontWeight: FontWeight.w700,
                          ),
                        ))
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          "Seat Numbers :",
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 22,
                            fontFamily: "Raleway",
                            fontWeight: FontWeight.w700,
                          ),
                        )),
                        Expanded(
                            child: Text(
                          "${widget.selectedSeatsNo.map((e) => e.toString()).join(', ')}",
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 22,
                            fontFamily: "Raleway",
                            fontWeight: FontWeight.w700,
                          ),
                        ))
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Child Count :",
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 22,
                              fontFamily: "Raleway",
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Enter child count',
                            ),
                            onChanged: (value) {
                              // Handle the value change

                              setState(() {
                                if (value != "") {
                                  childPaymentTotal = childPayment *
                                      int.parse(value) *
                                      int.parse(routeData['distance']
                                          .replaceAll(RegExp(r'[^0-9]'), ''));

                                  seatCountPaymentChild =
                                      (seatCountPaymentChild +
                                          int.parse(value));
                                } else {
                                  childPaymentTotal = 0;
                                  seatCountPaymentChild = 0;
                                }
                                totalPayment =
                                    childPaymentTotal + elderPaymentTotal;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          "Elder Count :",
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 22,
                            fontFamily: "Raleway",
                            fontWeight: FontWeight.w700,
                          ),
                        )),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Enter elder count',
                            ),
                            onChanged: (value) {
                              setState(() {
                                if (value != "") {
                                  elderPaymentTotal = (elderPayment *
                                      int.parse(value) *
                                      int.parse(routeData['distance']
                                          .replaceAll(RegExp(r'[^0-9]'), '')));
                                  seatCountPaymentElder =
                                      seatCountPaymentElder + int.parse(value);
                                } else {
                                  elderPaymentTotal = 0;
                                  seatCountPaymentElder = 0;
                                }
                                totalPayment =
                                    childPaymentTotal + elderPaymentTotal;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          "Payment",
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 22,
                            fontFamily: "Raleway",
                            fontWeight: FontWeight.w700,
                          ),
                        )),
                        Expanded(
                            child: Text(
                          '${totalPayment}',
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 22,
                            fontFamily: "Raleway",
                            fontWeight: FontWeight.w700,
                          ),
                        ))
                      ],
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        // sendEmail();
                        // print(seatCountPaymentChild);
                        // print(seatCountPaymentElder);
                        int paymentSeatsCount =
                            seatCountPaymentChild + seatCountPaymentElder;
                        _paymentProcess(
                            widget.selectedSeats.length, paymentSeatsCount);
                      },
                      child: Text("Pay"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _paymentProcess(int seatCount, int paymentSeatsCount) async {
    // print(seatCount);
    // print(paymentSeatsCount);
    setState(() {
      isLoading = true; // Set loading to true
    });
    Color color = Colors.green;
    String message = "";
    if (seatCount == paymentSeatsCount) {
      Map<String, dynamic> userData = storage.getItem('user');
      String uid = userData['uid'];
      await getUser(uid);
      String email = userDataDatabase['email'];
      String nic = userDataDatabase['nicPassport'];
      String mobile = userDataDatabase['mobile'];
      String gender = userDataDatabase['gender'];
      String bookedPerson;
      if (gender == "Male") {
        bookedPerson = "M";
      } else {
        bookedPerson = "FM";
      }

      await sendEmail(
          email,
          nic,
          mobile,
          totalPayment,
          routeData,
          busData,
          widget.selectedSeats.length,
          seatCountPaymentChild,
          seatCountPaymentElder);

      // Use a for loop to update each selected seat
      for (String seatId in widget.selectedSeats) {
        await updateSeatAvailability(
            widget.routeId, widget.busId, seatId, false, bookedPerson);
      }

      await bookSeat(
          userDataDatabase['id'],
          routeData['route'],
          busData['runningNo'],
          widget.selectedSeatsNo,
          widget.selectedSeats,
          busData['time'],
          routeData['id'],
          busData['id']);

      message = "Seats booked successfully.Check email for invoice";

      scheduleNotification(10, "Donr");

      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      });
    } else if (paymentSeatsCount < seatCount) {
      message =
          "Please check your selected seats count. You have more ${seatCount - paymentSeatsCount} seats";
      color = Colors.red;
    } else {
      message =
          "Please check your selected seats count exceeded. You selected only ${seatCount} seats";
      color = Colors.red;
    }

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
    setState(() {
      isLoading = false;
    });
  }

  Future<void> updateSeatAvailability(String routeId, String busId,
      String seatId, bool isAvailable, String bookedPerson) async {
    try {
      print("Updating seat availability for seatId: $seatId");

      // Check if the seat is available
      DocumentSnapshot seatSnapshot = await FirebaseFirestore.instance
          .collection('routes')
          .doc(routeId)
          .collection('buses')
          .doc(busId)
          .collection('seats')
          .doc(seatId)
          .get();

      if (seatSnapshot.exists) {
        Map<String, dynamic> data = seatSnapshot.data() as Map<String, dynamic>;
        bool currentAvailability = data['availability'];
        if (currentAvailability) {
          // Seat is available, update availability and booked_person
          await FirebaseFirestore.instance
              .collection('routes')
              .doc(routeId)
              .collection('buses')
              .doc(busId)
              .collection('seats')
              .doc(seatId)
              .update({
            'availability': isAvailable,
            'booked_person': bookedPerson ?? '',
          });

          print('Seat availability updated successfully');
        } else {
          print('Seat is not available');
        }
      } else {
        print('Seat not found');
      }
    } catch (e) {
      print('Error updating seat availability: $e');
    }
  }

  Future<void> bookSeat(
      String userId,
      String routeId,
      String busId,
      List<int> seatNumbers,
      List<String> seatIds,
      busTime,
      route_Id,
      bus_Id) async {
    try {
      CollectionReference userCollection =
          FirebaseFirestore.instance.collection('users');

      await userCollection.doc(userId).collection('booked_seats').doc().set({
        'route_Id': route_Id,
        'routeId': routeId,
        'bus_Id': bus_Id,
        'busId': busId,
        'busTime': busTime,
        'seatIds': seatIds,
        'seatNumbers': seatNumbers,
        'bookedDateTime': DateTime.now(),
      });

      print('Seat booked successfully');
    } catch (e) {
      print('Error booking seat: $e');
    }
  }

  Future<void> sendEmail(
      String email,
      String nic,
      String mobile,
      double totalPayment,
      Map<String, dynamic> routeData,
      Map<String, dynamic> busData,
      int seatCount,
      int seatCountPaymentChild,
      int seatCountPaymentElder) async {
    final smtpServer = SmtpServer('smtp.gmail.com',
        username: 'assignmentct73@gmail.com', password: 'xgdjtokorviqmnxq');

    final message = mailer.Message()
      ..from = Address('assignmentct73@gmail.com', 'Go Bus Now')
      ..recipients.add('sjeewaranga@gmail.com')
      // ..recipients.add(email)
      ..subject = 'Payment Receipt for Your Booking'
      ..html = '''
                <html>
                  <head>
                    <style>
                      body {
                        font-family: Arial, sans-serif;
                        margin: 0;
                        padding: 0;
                        background-color: #f9f9f9;
                      }
                      .container {
                        max-width: 600px;
                        margin: 0 auto;
                        padding: 20px;
                        background-color: #fff;
                        border: 1px solid #ddd;
                        border-radius: 5px;
                      }
                      h1 {
                        color: #333;
                        text-align: center;
                        margin-bottom: 20px;
                      }
                      p {
                        color: #666;
                        font-size: 16px;
                        line-height: 1.5;
                        margin-bottom: 10px;
                      }
                      .footer {
                        margin-top: 20px;
                        text-align: center;
                        color: #888;
                      }
                     
                    </style>
                  </head>
                  <body>
                    <div class="container">
                      
                      <h1>Payment Receipt</h1>
                      <p>Dear Customer,</p>
                      <p>Your payment of <span style="color: #009688; font-weight: bold;">${totalPayment.toStringAsFixed(2)}</span> has been received.</p>
                      <p>NIC/Passport: <span style="color: #009688; font-weight: bold;">$nic</span></p>
                      <p>Mobile Number: <span style="color: #009688; font-weight: bold;">$mobile</span></p>
                      <p>Route: <span style="color: #009688; font-weight: bold;">${routeData['route']} - ${routeData['route_no']}</span></p>
                      <p>Bus: <span style="color: #009688; font-weight: bold;">${busData != null ? busData['runningNo'] : ''}</span></p>
                      
                      <p>Time: <span style="color: #009688; font-weight: bold;">${busData != null ? busData['time'] : ''}</span></p>
                      <p>Number of Seats Booked: <span style="color: #009688; font-weight: bold;">$seatCount</span></p>
                      <p>Child Seat Count: <span style="color: #009688; font-weight: bold;">$seatCountPaymentChild</span></p>
                      <p>Elder Seat Count: <span style="color: #009688; font-weight: bold;">$seatCountPaymentElder</span></p>
                       <p>Booking Date and Time: <span style="color: #009688; font-weight: bold;">${DateTime.now().toString()}</span></p>
                      <p>Thank you for choosing our service.</p>
                      <p class="footer">Regards,<br>Go Bus Now Team</p>
                    </div>
                  </body>
                  </html>

    ''';
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.messageSendingStart}');
    } catch (e) {
      print('Error occurred while sending email: $e');
    }
  }
}
