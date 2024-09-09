import 'package:crm_primine/auth/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/Credentials.dart';
import '../screens/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _authenticate() async {
    final credentials = Credentials(
      email: _emailController.text,
      password: _passwordController.text,
    );
    

    // Admin check
    if (credentials.email == 'admin@gmail.com' && credentials.password == 'admin@123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardPage(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Admin login successful')),
      );
    } else {
      final response = await http.post(
        Uri.parse('http://192.44.24.23/login'), // Use the local IP for Android emulator
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': credentials.email,
          'password': credentials.password,
        }),
      );


      if (response.statusCode == 200) {
        // Login successful, navigate to Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardPage(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful')),
        );
      } else if (response.statusCode == 401) {
        // Unauthorized, show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid email or password')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred')),
        );
      }
    }
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logged out successfully')),
    );
  }

  Widget _buildTextFieldWithIcon(
      IconData icon,
      String hintText, {
        required TextEditingController controller,
        required bool obscureText,
        required Color color,
        required String validator,
      }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: color,
        ),
        hintText: hintText,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validator;
        }
        return null;
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _authenticate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color darkNavyBlue = Color(0xFF000035);

    return Scaffold(
      appBar: AppBar(
        title: Text('Primine CRM'),
        backgroundColor: darkNavyBlue,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: darkNavyBlue,
              ),
              child: Text(
                'Primine CRM',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 50),
            Text(
              'Login',
              style: TextStyle(fontSize: 30, color: darkNavyBlue),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextFieldWithIcon(
                    Icons.email,
                    'Email',
                    controller: _emailController,
                    obscureText: false,
                    color: darkNavyBlue,
                    validator: 'Please enter email',
                  ),
                  const SizedBox(height: 20.0),
                  _buildTextFieldWithIcon(
                    Icons.lock,
                    'Password',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    color: darkNavyBlue,
                    validator: 'Please enter password',
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: darkNavyBlue,
                      ),
                      child: const Text('Log In'),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegistrationPage(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? "),
                        Text(
                          'Register',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: darkNavyBlue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
