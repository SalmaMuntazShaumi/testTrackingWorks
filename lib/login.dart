import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_works/config.dart';
import 'package:tracking_works/main.dart';

import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final String baseUrl = 'https://krista-staging.trackingworks.io';
  String name = '';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          'ESCA HRIS',
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        padding: EdgeInsets.all(30),
        child: Form(
          child: Column(
            children: <Widget>[
              Image.asset(
                "assets/icons/icon.png",
                width: size.width * 0.25,
              ),
              Padding(
                padding: EdgeInsets.all(20),
              ),
              Text(
                "Masuk",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.all(5)),
              const Text(
                "Silahkan masuk untuk menggunakan aplikasi ini",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Masukkan alamat E-mail Anda',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              PasswordField(
                controller: _passwordController,
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Lupa password Anda?",
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Klik disini",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width - 2 * 24,
                child: ElevatedButton(
                  onPressed: () async {
                    await _login(
                        _emailController.text, _passwordController.text);
                  },
                  child: Text('Masuk',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Ganti URL",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _login(String email, String password) async {
    Map<String, String> headers = {'user-device': '97a95688f6ad1ab4'};

    Map<String, String> body = {'email': email, 'password': password};

    print(body);

    setState(() {
      _isLoading = true;
    });
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/api/v1/employee/authentication/login'),
        headers: headers,
        body: body,
      );

      print(res.statusCode);
      print(res.body.toString());
      var response = jsonDecode(res.body);

      if (res.statusCode == 200) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        var error = response['meta']['error'];
        final snackBar = SnackBar(
          content: Text(
            error,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({Key? key, this.controller}) : super(key: key);
  final controller;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isShowPassword = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: !_isShowPassword,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Password',
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _isShowPassword = !_isShowPassword;
            });
          },
          child: Icon(
            _isShowPassword ? Icons.visibility_off : Icons.visibility,
          ),
        ),
      ),
    );
  }
}
