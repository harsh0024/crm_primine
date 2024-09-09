import 'dart:convert'; // For encoding and decoding JSON
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_contact_page.dart'; // Import the AddContactPage

class ContactListingPage extends StatefulWidget {
  @override
  _ContactListingPageState createState() => _ContactListingPageState();
}

class _ContactListingPageState extends State<ContactListingPage> {
  List<Map<String, dynamic>> _contacts = []; // Empty list for contacts
  bool _showDetails = false;
  dynamic _selectedContact;
  String _searchQuery = '';
  List<Map<String, dynamic>> _filteredContacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts(); // Load saved contacts when the app starts
  }

  // Load contacts from SharedPreferences
  Future<void> _loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? contactsString = prefs.getString('contacts'); // Retrieve stored contacts

    if (contactsString != null) {
      setState(() {
        _contacts = List<Map<String, dynamic>>.from(jsonDecode(contactsString)); // Decode and set contacts
        _filteredContacts = _contacts;
      });
    }
  }

  // Save contacts to SharedPreferences
  Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('contacts', jsonEncode(_contacts)); // Save the contacts as a JSON string
  }

  // Navigate to AddContactPage to add a new contact
  void _navigateToAddContactPage() async {
    final newContact = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddContactPage()),
    );

    if (newContact != null) {
      setState(() {
        _contacts.add(newContact); // Add new contact to the list
        _filteredContacts = _contacts; // Update the filtered contacts
      });
      _saveContacts(); // Save updated contacts to SharedPreferences after adding
    }
  }

  // Handle search query change
  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      _filteredContacts = _contacts
          .where((contact) =>
      contact['firstName'].toLowerCase().contains(query.toLowerCase()) ||
          contact['lastName'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Sort contacts by name
  void _sortContacts() {
    setState(() {
      _filteredContacts.sort((a, b) =>
          '${a['firstName']} ${a['lastName']}'.compareTo('${b['firstName']} ${b['lastName']}'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact List',),
        backgroundColor: Color(0xFF000035),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ContactSearchDelegate(
                  contacts: _contacts,
                  onSearch: _updateSearchQuery,
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.sort, color: Colors.white),
            onPressed: _sortContacts,
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              // Handle menu options here
            },
            itemBuilder: (BuildContext context) {
              return ['Option 1', 'Option 2'].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: _showDetails ? _buildDetailView() : _buildContactListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddContactPage,
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF000035),
      ),
    );
  }

  Widget _buildContactListView() {
    return _filteredContacts.isEmpty
        ? Center(child: Text('No contacts found. Tap the "+" button to add a contact.'))
        : ListView.builder(
      itemCount: _filteredContacts.length,
      itemBuilder: (context, index) {
        final contact = _filteredContacts[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text((index + 1).toString()), // Serial number
          ),
          title: Text('${contact['firstName']} ${contact['lastName']}'),
          onTap: () {
            setState(() {
              _selectedContact = contact;
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
          'Name: ${_selectedContact['firstName']} ${_selectedContact['lastName']}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text('Email: ${_selectedContact['email']}', style: TextStyle(fontSize: 16)),
        SizedBox(height: 10),
        Text('Phone: ${_selectedContact['phone']}', style: TextStyle(fontSize: 16)),
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

class ContactSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> contacts;
  final Function(String) onSearch;

  ContactSearchDelegate({required this.contacts, required this.onSearch});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearch(query);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = contacts.where((contact) =>
    contact['firstName'].toLowerCase().contains(query.toLowerCase()) ||
        contact['lastName'].toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final contact = results[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text((index + 1).toString()), // Serial number
          ),
          title: Text('${contact['firstName']} ${contact['lastName']}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContactDetailPage(contact: contact),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = contacts.where((contact) =>
    contact['firstName'].toLowerCase().contains(query.toLowerCase()) ||
        contact['lastName'].toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final contact = suggestions[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text((index + 1).toString()), // Serial number
          ),
          title: Text('${contact['firstName']} ${contact['lastName']}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContactDetailPage(contact: contact),
              ),
            );
          },
        );
      },
    );
  }
}

class ContactDetailPage extends StatelessWidget {
  final Map<String, dynamic> contact;

  ContactDetailPage({required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Details',),
        backgroundColor: Color(0xFF000035),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${contact['firstName']} ${contact['lastName']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Email: ${contact['email']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Phone: ${contact['phone']}', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
