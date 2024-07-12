import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> signup(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    _setLoading(true, context);
    final url = Uri.parse('http://210.247.245.155:8000/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': firstNameController.text +' '+lastNameController.text,
        'email': emailController.text,
        'telp': phoneController.text,
        'password': passwordController.text,
      }),
    );

    _setLoading(false, context);

    if (response.statusCode == 200) {
      // Handle successful signup
      final responseData = json.decode(response.body);
      print(responseData);
      // Save token, navigate to another screen, etc.
    } else {
      // Handle signup failure
      final error = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error['message'])),
      );
    }
  }

  void _setLoading(bool value, BuildContext context) {
    _isLoading = value;
    (context as Element).markNeedsBuild(); // Force rebuild to update the UI
  }

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
  }
}
