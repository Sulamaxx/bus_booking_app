import 'package:bus_booking_app/models/user.dart';
import 'package:bus_booking_app/screens/auth/login_screen.dart';
import 'package:bus_booking_app/screens/main/home_sceen.dart';
import 'package:bus_booking_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nicPassportController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  String _selectedGender = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.sign_up_btn),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(
                    'assets/logo_bus_booking_app.png',
                  ),
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _emailController,
                  decoration:  InputDecoration(
                    labelText: AppLocalizations.of(context)!.email,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.email_validation_empty;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _passwordController,
                  decoration:  InputDecoration(
                    labelText: AppLocalizations.of(context)!.password,
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.password_validation_empty;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _nicPassportController,
                  decoration:  InputDecoration(
                    labelText: AppLocalizations.of(context)!.nic_passport,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.nic_passport_validation;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.number,
                  decoration:  InputDecoration(
                    labelText: AppLocalizations.of(context)!.mobile_number,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.mobile_number_validation;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                DropdownButtonFormField<String>(
                  value: _selectedGender.isNotEmpty ? _selectedGender : null,
                  items: [AppLocalizations.of(context)!.gender_male, AppLocalizations.of(context)!.gender_female].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue!;
                    });
                  },
                  decoration:  InputDecoration(
                    labelText: AppLocalizations.of(context)!.gender,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.gender_validation;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _signUp(context);
                    }
                  },
                  child:  Text(AppLocalizations.of(context)!.sign_up_btn),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.already_exist_account,
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

  void _signUp(context) async {
    UserModel user = UserModel(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      nic: _nicPassportController.text.trim(),
      mobile: _mobileController.text.trim(),
      gender: _selectedGender,
    );
    Color color = Colors.red;
    String output;
    String? message = await _authService.signUpWithEmailAndPassword(user,context);

    if (message ==
        "[firebase_auth/weak-password] Password should be at least 6 characters") {
      output = AppLocalizations.of(context)!.sign_up_auth_password_length;
      color = Colors.red;
    } else if (message ==
        "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
      output = AppLocalizations.of(context)!.sign_up_auth_email_already_exist;
      color = Colors.red;
    } else if (message ==
        "[firebase_auth/invalid-email] The email address is badly formatted.") {
      output = AppLocalizations.of(context)!.sign_up_auth_invalid_email;
      color = Colors.red;
    } else {
      output = message!;
      if (message == AppLocalizations.of(context)!.sign_up_auth_register_success) {
        color = Colors.green;
      } else {
        color = Colors.red;
      }
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
          output,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );

    if (output == AppLocalizations.of(context)!.sign_up_auth_register_success) {
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      });
    }
  }
}
