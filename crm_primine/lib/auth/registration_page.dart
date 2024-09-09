import 'dart:convert';
import 'package:crm_primine/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/User.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}


class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      final user = User(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        contactNumber: _contactController.text.trim(),
        password: _passwordController.text,
      );

      try {
        final response = await http.post(
          Uri.parse('http://192.168.29.32/users.php'), // Ensure the URL is correct
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'firstName': user.firstName,
            'lastName': user.lastName,
            'email': user.email,
            'contactNumber': user.contactNumber,
            'password': user.password,
          }),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          if (responseData['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registration successful')),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registration failed: ${responseData['message']}')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Server error: ${response.statusCode}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Primine CRM'),
        backgroundColor: Color(0xFF000035),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Registration',
                  style: TextStyle(fontSize: 30, color: Color(0xFF000035)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                _buildTextField(
                  _firstNameController,
                  'First Name',
                  Icons.person,
                      (value) => value!.isEmpty ? 'First Name is required' : null,
                ),
                const SizedBox(height: 10.0),
                _buildTextField(
                  _lastNameController,
                  'Last Name',
                  Icons.person,
                      (value) => value!.isEmpty ? 'Last Name is required' : null,
                ),
                const SizedBox(height: 10.0),
                _buildTextField(
                  _emailController,
                  'Email',
                  Icons.email,
                      (value) {
                    if (value!.isEmpty) return 'Email is required';
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                    if (!emailRegex.hasMatch(value))
                      return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                _buildTextField(
                  _contactController,
                  'Contact Number',
                  Icons.phone,
                      (value) => value!.isEmpty ? 'Contact Number is required' : null,
                ),
                const SizedBox(height: 10.0),
                _buildTextField(
                  _passwordController,
                  'Password',
                  Icons.lock,
                      (value) => value!.isEmpty ? 'Password is required' : null,
                  obscureText: true,
                ),
                const SizedBox(height: 10.0),
                _buildTextField(
                  _confirmPasswordController,
                  'Confirm Password',
                  Icons.lock,
                      (value) {
                    if (value!.isEmpty) return 'Confirm Password is required';
                    if (value != _passwordController.text)
                      return 'Passwords do not match';
                    return null;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF000035),
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Register'),
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? "),
                      Text(
                        'Login',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000035),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller,
      String hintText,
      IconData icon,
      String? Function(String?) validator, {
        bool obscureText = false,
      }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Color(0xFF000035)),
        hintText: hintText,
        border: OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}
