import 'package:bus_booking_app/screens/auth/login_screen.dart';
import 'package:bus_booking_app/screens/auth/signup_screen.dart';
import 'package:bus_booking_app/screens/main/home_sceen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:localstorage/localstorage.dart';

final LocalStorage storage = LocalStorage('user.json');

class Wrapper extends StatelessWidget {
  final void Function(String, String) changeLanguage;
  final Locale locale;

  const Wrapper({Key? key, required this.changeLanguage, required this.locale})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (storage.getItem("user") != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    });

    return MyHomePage(
      changeLanguage: changeLanguage,
      locale: locale,
    );
  }
}

class MyHomePage extends StatelessWidget {
  final void Function(String, String) changeLanguage;
  final Locale locale;

  const MyHomePage(
      {Key? key, required this.changeLanguage, required this.locale})
      : super(key: key);

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
                    Image(
                      image: AssetImage(
                        'assets/logo_bus_booking_app.png',
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      AppLocalizations.of(context)!.welcome,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInScreen(),
                        ),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.sign_in_btn),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.sign_up_btn),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DropdownButton<String>(
                    value: '${locale.languageCode}_${locale.countryCode}',
                    items: const [
                      DropdownMenuItem(
                        child: Text('Eng'),
                        value: 'en_US',
                      ),
                      DropdownMenuItem(
                        child: Text('Sin'),
                        value: 'si_LK',
                      ),
                      DropdownMenuItem(
                        child: Text('Jap'),
                        value: 'ja_JP',
                      ),
                      DropdownMenuItem(
                        child: Text('Spa'),
                        value: 'es_ES',
                      ),
                    ],
                    onChanged: (String? value) {
                      if (value != null) {
                        final parts = value.split('_');
                        changeLanguage(parts[0], parts[1]);
                      }
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
