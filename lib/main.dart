import 'dart:io';

import 'package:bus_booking_app/screens/auth/login_screen.dart';
import 'package:bus_booking_app/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus Finder App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: Colors.grey[900],
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
          labelLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: AssetImage('assets/logo_bus_booking_app.png')),
                    SizedBox(height: 20.0),
                    Text('Welcome!', style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
                    },
                    child: Text('Sign In'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                    },
                    child: Text('Sign Up'),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DropdownButton<String>(
                    items: const [
                      DropdownMenuItem(child: Text('Eng'), value: 'Eng'),
                      DropdownMenuItem(child: Text('Sin'), value: 'Sin'),
                      DropdownMenuItem(child: Text('Jap'), value: 'Jap'),
                      DropdownMenuItem(child: Text('Spa'), value: 'Spa'),
                    ],
                    onChanged: (String? value) {
                    },
                    underline: Container(),
                    icon: Icon(Icons.language),
                    iconSize: 30.0,
                    dropdownColor: Colors.grey[850],
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
