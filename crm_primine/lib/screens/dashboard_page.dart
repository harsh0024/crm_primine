import 'package:flutter/material.dart';
import 'lead_listing_page.dart';
import 'contact_listing_page.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Primine CRM'),
        backgroundColor: Color(0xFF000035), // Dark navy blue color
        titleTextStyle: TextStyle(
          color: Colors.white, // White color for AppBar text
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // White color for AppBar icons
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Handle search
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
        UserAccountsDrawerHeader(
        accountName: Text('John Doe'),
        accountEmail: Text('john.doe@example.com'),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(
            'J',
            style: TextStyle(fontSize: 40.0, color: Colors.black),
          ),
        ),
        decoration: BoxDecoration(
          color: Color(0xFF000035), // Dark navy blue color
        ),
      ),
      ListTile(
        leading: Icon(Icons.home),
        title: Text('Home'),
        onTap: () {
          // Handle home navigation
          Navigator.pop(context); // Close the drawer
        },
      ),
      ListTile(
        leading: Icon(Icons.feed),
        title: Text('Feeds'),
        onTap: () {
          // Handle feeds navigation
          Navigator.pop(context); // Close the drawer
        },
      ),
      ListTile(
        leading: Icon(Icons.person),
        title: Text('Leads'),
        onTap: () {
          // Navigate to the Lead Listing Page
          Navigator.pop(context); // Close the drawer first
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LeadListingPage()),
          );
        },
      ),
            ListTile(
              leading: Icon(Icons.contacts),
              title: Text('Contact'),
              onTap: () {
                // Handle contact navigation
                Navigator.pop(context); // Close the drawer first
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactListingPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Accounts'),
              onTap: () {
                // Handle accounts navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.monetization_on),
              title: Text('Deals'),
              onTap: () {
                // Handle deals navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.task),
              title: Text('Tasks'),
              onTap: () {
                // Handle tasks navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.meeting_room),
              title: Text('Meetings'),
              onTap: () {
                // Handle meetings navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.call),
              title: Text('Calls'),
              onTap: () {
                // Handle calls navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.sync_disabled),
              title: Text('Unsynced Record'),
              onTap: () {
                // Handle unsynced record navigation
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Setting'),
              onTap: () {
                // Handle settings navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text('Feedback'),
              onTap: () {
                // Handle feedback navigation
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Dashboard',
              style: TextStyle(fontSize: 30, color: Color(0xFF000035)), // Dark navy blue color
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(10),
                children: <Widget>[
                  _buildCard(
                    context,
                    'Confirmed Lead',
                    Icons.add_circle,
                    Colors.deepPurpleAccent,
                        () {
                      // Implement navigation to Confirmed Lead page
                    },
                  ),
                  _buildCard(
                    context,
                    'Lead Listing',
                    Icons.person,
                    Colors.teal,
                        () {
                      // Navigate to Lead Listing Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LeadListingPage()),
                      );
                    },
                  ),
                  _buildCard(
                    context,
                    'Create Task',
                    Icons.add_task,
                    Colors.orange,
                        () {
                      // Implement navigation to Create Task page
                    },
                  ),
                  _buildCard(
                    context,
                    'Task Status',
                    Icons.toggle_on,
                    Colors.red,
                        () {
                      // Implement navigation to Task Status page
                    },
                  ),
                  _buildCard(
                    context,
                    'Analyze',
                    Icons.analytics,
                    Colors.blue,
                        () {
                      // Implement navigation to Analyze page
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, Color color, Function onTap) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          onTap(); // Call the function passed to the card
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 60,
              color: color,
            ),
            SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000035),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
