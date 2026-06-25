import 'package:assignment/Screens/login.dart';
import 'package:assignment/Screens/courses.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final subjects = ["Mobile App Development", "Software Re-engineering", "MIS"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Column(
        children: [
          CircleAvatar(radius: 40),
          Text("Welcome User"),
          Expanded(
            child: ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(subjects[index]),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/detail',
                      arguments: subjects[index],
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton.icon(
              icon: Icon(Icons.menu_book),
              label: Text("Manage Courses (API)"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CoursesScreen()),
                );
              },
            ),
          ),
          ElevatedButton(
            child: Text("Logout"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
            },
          )
        ],
      ),
    );
  }
}