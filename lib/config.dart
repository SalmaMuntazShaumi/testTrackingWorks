import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Configuration {
  final String baseUrl = 'https://krista-staging.trackingworks.io';

  Future<dynamic> login(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('uuid', '97a95688f6ad1ab4');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String uuid = prefs.getString('uuid') ?? '-';
      Map<String, String> headers = {'user-device': uuid};
      Map<String, String> body = {'email': email, 'password': password};

      print(uuid);
      http.Response res = await http.post(
        Uri.parse('$baseUrl/api/v1/employee/authentication/login'),
        headers: headers,
        body: body,
      );
      return res;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> getSchedule(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    String uuid = prefs.getString('uuid') ?? '-';

    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'user-device': uuid
      };
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      String date = formatter.format(DateTime.now());

      http.Response res = await http.get(
        Uri.parse('$baseUrl/api/v1/employee/schedule?$date'),
        headers: headers,
      );

      if (res.statusCode != 200) {
        var response = jsonDecode(res.body);
        final snackBar = buildSnackbar(response['meta']['error']);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      return res;
    } catch (e) {
      final snackBar = buildSnackbar(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return e.toString();
    }
  }

  Future<dynamic> postAttendance(BuildContext context) async {


    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    String uuid = '3be04337da34cd62';

    try {


      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'user-device': uuid
      };

      DateFormat formatter = DateFormat('yyyy-MM-dd');
      DateFormat clockFormatter = DateFormat('HH:mm:ss');
      String date = formatter.format(DateTime.now());
      String clock = clockFormatter.format(DateTime.now());

      Map<String, dynamic> body = {
        'date': date.toString(),
        'clock': clock.toString(),
        'type': 'normal',
      };

      http.Response resData = await http.post(
          Uri.parse('$baseUrl/api/v1/employee/attendance-check-clocked'),
          headers: headers,
          body: body);

      if (resData.statusCode != 200) {
        print(resData.body.toString());
        print(date);
        var response = jsonDecode(resData.body);
        print(response['meta']);
        final snackBar = buildSnackbar(response['meta']['message']);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      return resData;
    } catch (e) {
    }
  }
  }

  SnackBar buildSnackbar(String text) {
    return SnackBar(
      content: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
  }

