import 'dart:async';

import 'package:bus_booking_app/l10n/l4n.dart';
import 'package:bus_booking_app/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en', 'US');

  void changeLanguage(String languageCode, String countryCode) {
    setState(() {
      _locale = Locale(languageCode, countryCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus Finder App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: Colors.grey[900],
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          labelLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ),
      supportedLocales: L10n.all,
      locale: _locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Wrapper(changeLanguage: changeLanguage, locale: _locale),
    );
  }
}

// class MyHomePage extends StatelessWidget {
//   final void Function(String, String) changeLanguage;
//
//   const MyHomePage({Key? key, required this.changeLanguage}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image(
//                       image: AssetImage(
//                         'assets/logo_bus_booking_app.png',
//                       ),
//                     ),
//                     SizedBox(height: 20.0),
//                     Text(
//                       AppLocalizations.of(context)!.welcome,
//                       style: Theme
//                           .of(context)
//                           .textTheme
//                           .titleLarge,
//                     ),
//                   ],
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => SignInScreen(),
//                         ),
//                       );
//                     },
//                     child: Text(AppLocalizations.of(context)!.sign_in_btn),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => SignUpScreen(),
//                         ),
//                       );
//                     },
//                     child: Text(AppLocalizations.of(context)!.sign_up_btn),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   DropdownButton<String>(
//                     value: '${MyApp
//                         .of(context)
//                         ._locale
//                         .languageCode}_${MyApp
//                         .of(context)
//                         ._locale
//                         .countryCode}',
//                     items: const [
//                       DropdownMenuItem(
//                         child: Text('Eng'),
//                         value: 'en_US',
//                       ),
//                       DropdownMenuItem(
//                         child: Text('Sin'),
//                         value: 'si_LK',
//                       ),
//                       DropdownMenuItem(
//                         child: Text('Jap'),
//                         value: 'ja_JP',
//                       ),
//                       DropdownMenuItem(
//                         child: Text('Spa'),
//                         value: 'es_ES',
//                       ),
//                     ],
//                     onChanged: (String? value) {
//                       if (value != null) {
//                         final parts = value.split('_');
//                         changeLanguage(parts[0], parts[1]);
//                       }
//                     },
//                     underline: Container(),
//                     icon: Icon(Icons.language),
//                     iconSize: 30.0,
//                     dropdownColor: Colors.grey[850],
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
