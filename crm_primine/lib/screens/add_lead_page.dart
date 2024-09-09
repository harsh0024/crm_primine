import 'package:flutter/material.dart';

class AddLeadPage extends StatefulWidget {
  @override
  _AddLeadPageState createState() => _AddLeadPageState();
}

class _AddLeadPageState extends State<AddLeadPage> {
  final _formKey = GlobalKey<FormState>();

  // Form field controllers
  final TextEditingController _leadOwnerController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _salutationController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _leadOwnerController.dispose();
    _companyController.dispose();
    _salutationController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveLead() {
    if (_formKey.currentState!.validate()) {
      // Create a new lead object
      final newLead = {
        'leadOwner': _leadOwnerController.text,
        'company': _companyController.text,
        'salutation': _salutationController.text,
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
      };

      // Return the new lead to the previous screen
      Navigator.pop(context, newLead);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Lead',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF000035),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _leadOwnerController,
                decoration: InputDecoration(labelText: 'Lead Owner'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the lead owner';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _companyController,
                decoration: InputDecoration(labelText: 'Company'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the company';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _salutationController,
                decoration: InputDecoration(labelText: 'Salutation'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the salutation';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveLead,
                child: Text(
                  'Save Lead',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF000035),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
