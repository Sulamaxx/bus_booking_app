import 'package:bus_booking_app/screens/auth/signup_screen.dart';
import 'package:bus_booking_app/screens/main/home_sceen.dart';
import 'package:bus_booking_app/services/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("payment Page"),
      ),
      body: SingleChildScrollView(
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
              Text("Payment",style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 22,
                fontFamily: "Raleway",
                fontWeight: FontWeight.w700,
              ),),
              SizedBox(height: 25.0),








              Row(
                children: [

                  Expanded(child: Text(
                    "Seat Count",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 22,
                      fontFamily: "Raleway",
                      fontWeight: FontWeight.w700,

                    ),
                  )


                  ),
                  Expanded(child: Text(
                    "Selected count",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 22,
                      fontFamily: "Raleway",
                      fontWeight: FontWeight.w700,

                    ),
                  )

                  )


                ],
              ),
              SizedBox(height: 20.0),
              Row(
                children: [

                  Expanded(child: Text(
                    "Seat Numbers",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 22,
                      fontFamily: "Raleway",
                      fontWeight: FontWeight.w700,

                    ),
                  )


                  ),
                  Expanded(child: Text(
                    "Selected Numbers",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 22,
                      fontFamily: "Raleway",
                      fontWeight: FontWeight.w700,

                    ),
                  )

                  )


                ],
              ),
              SizedBox(height: 20.0),
              Row(
                children: [

                  Expanded(child: Text(
                    "Child Count",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 22,
                      fontFamily: "Raleway",
                      fontWeight: FontWeight.w700,

                    ),
                  )


                  ),
                  Expanded(child: Text(
                    "Booking for Child",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 22,
                      fontFamily: "Raleway",
                      fontWeight: FontWeight.w700,

                    ),
                  )

                  )


                ],
              ),
              SizedBox(height: 20.0),
              Row(
                children: [

                  Expanded(child: Text(
                    "Elder Count",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 22,
                      fontFamily: "Raleway",
                      fontWeight: FontWeight.w700,

                    ),
                  )


                  ),
                  Expanded(child: Text(
                    "Booking for Elder",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 22,
                      fontFamily: "Raleway",
                      fontWeight: FontWeight.w700,

                    ),
                  )

                  )


                ],
              ),
              SizedBox(height: 20.0),
              Row(
                children: [

                  Expanded(child: Text(
                    "Payment",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 22,
                      fontFamily: "Raleway",
                      fontWeight: FontWeight.w700,

                    ),
                  )


                  ),
                  Expanded(child: Text(
                    "Child + Elder Price",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 22,
                      fontFamily: "Raleway",
                      fontWeight: FontWeight.w700,

                    ),
                  )

                  )


                ],
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpScreen(),
                    ),
                  );
                },
                child: Text("pay"),
              ),

            ],

          ),
        ),
      ),
    );
  }

}