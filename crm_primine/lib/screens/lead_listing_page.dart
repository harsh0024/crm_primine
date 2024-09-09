import 'dart:convert'; // For encoding and decoding JSON
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_lead_page.dart';

class LeadListingPage extends StatefulWidget {
  @override
  _LeadListingPageState createState() => _LeadListingPageState();
}

class _LeadListingPageState extends State<LeadListingPage> {
  List<Map<String, dynamic>> _leads = []; // Empty list for leads
  bool _showDetails = false;
  dynamic _selectedLead;

  @override
  void initState() {
    super.initState();
    _loadLeads(); // Load saved leads when the app starts
  }

  // Load leads from SharedPreferences
  Future<void> _loadLeads() async {
    final prefs = await SharedPreferences.getInstance();
    final String? leadsString = prefs.getString('leads'); // Retrieve stored leads

    if (leadsString != null) {
      setState(() {
        _leads = List<Map<String, dynamic>>.from(jsonDecode(leadsString)); // Decode and set leads
      });
    }
  }

  // Save leads to SharedPreferences
  Future<void> _saveLeads() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('leads', jsonEncode(_leads)); // Save the leads as a JSON string
  }

  // Navigate to AddLeadPage to add a new lead
  void _navigateToAddLeadPage() async {
    final newLead = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddLeadPage()),
    );

    if (newLead != null) {
      setState(() {
        _leads.add(newLead); // Add new lead to the list
      });
      _saveLeads(); // Save updated leads to SharedPreferences after adding
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lead List'),
        backgroundColor: Color(0xFF000035),
        titleTextStyle: TextStyle(
          color: Colors.white, // White color for AppBar text
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _showDetails ? _buildDetailView() : _buildLeadListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddLeadPage,
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF000035),
      ),
    );
  }

  Widget _buildLeadListView() {
    return _leads.isEmpty
        ? Center(child: Text('No leads yet. Tap the "+" button to add a lead.'))
        : ListView.builder(
      itemCount: _leads.length,
      itemBuilder: (context, index) {
        final lead = _leads[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text((index + 1).toString()), // Serial number
          ),
          title: Text('${lead['firstName']} ${lead['lastName']}'),
          onTap: () {
            setState(() {
              _selectedLead = lead;
              _showDetails = true;
            });
          },
        );
      },
    );
  }

  Widget _buildDetailView() {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        Text(
          'Name: ${_selectedLead['firstName']} ${_selectedLead['lastName']}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text('Email: ${_selectedLead['email']}', style: TextStyle(fontSize: 16)),
        SizedBox(height: 10),
        Text('Phone: ${_selectedLead['phone']}', style: TextStyle(fontSize: 16)),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _showDetails = false;
            });
          },
          child: Text('Back to List'),
        ),
      ],
    );
  }
}
