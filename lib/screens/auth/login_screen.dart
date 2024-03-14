import 'package:bus_booking_app/screens/auth/signup_screen.dart';
import 'package:bus_booking_app/screens/main/home_sceen.dart';
import 'package:bus_booking_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:localstorage/localstorage.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final LocalStorage storage = new LocalStorage('user.json');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.login_page_title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
                Image(
                  image: AssetImage(
                    'assets/logo_bus_booking_app.png',
                  ),
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.email,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!
                          .email_validation_empty;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.password,
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!
                          .password_validation_empty;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _signIn(context);
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.login_page_title),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.not_yet_register,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signIn(context) async {
    // Implement your sign-in logic here
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    String output = "";
    Color color = Colors.red;
    User? user = await _authService.signInWithEmailAndPassword(email, password);

    if (user == null) {
      output = AppLocalizations.of(context)!.auth_user_log_null;
      color = Colors.red;
    } else {
      Map<String, dynamic> userData = {
        'displayName': user.displayName,
        'email': user.email,
        'isEmailVerified': user.emailVerified,
        'isAnonymous': user.isAnonymous,
        'metadata': {
          'creationTime': user.metadata.creationTime.toString(),
          'lastSignInTime': user.metadata.lastSignInTime.toString(),
        },
        'phoneNumber': user.phoneNumber,
        'photoURL': user.photoURL,
        'providerData': user.providerData
            .map((info) => {
                  'displayName': info.displayName,
                  'email': info.email,
                  'phoneNumber': info.phoneNumber,
                  'photoURL': info.photoURL,
                  'providerId': info.providerId,
                  'uid': info.uid,
                })
            .toList(),
        'refreshToken': user.refreshToken,
        'tenantId': user.tenantId,
        'uid': user.uid,
      };

      // Convert the user data to JSON and store it
      storage.setItem("user", userData);
      output = AppLocalizations.of(context)!.auth_user_log_not_null;
      color = Colors.green;
      print(storage.getItem("user"));
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
          output!,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );

    if (output == AppLocalizations.of(context)!.auth_user_log_not_null) {
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      });
    }
  }
}
