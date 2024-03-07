import 'package:bus_booking_app/screens/auth/signup_screen.dart';
import 'package:bus_booking_app/screens/main/home_sceen.dart';
import 'package:bus_booking_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                    // if (_formKey.currentState!.validate()) {
                    //   _signIn();
                    // }
                    dynamic result = await _authService.signInAnon();
                    print(result);
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

  void _signIn() {
    // Implement your sign-in logic here
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => SeatSelectionScreen(seatsNeeded: 2)));
    // Now you can proceed with sign-in using the collected data
    // Example:
    // AuthService.signIn(email, password)
    //     .then((user) {
    //   // Handle successful sign-in
    // }).catchError((error) {
    //   // Handle sign-in error
    // });

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}
