import 'package:flutter/material.dart';
import 'package:gradbond/gradient_bg.dart';
import 'bottom_navigation.dart';

class FindAlumni extends StatelessWidget {
  const FindAlumni({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     "GradBond - Alumni Finder",
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      // ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Find Alumni of your University",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 20),
              const SearchForm(), 
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigation(context: context),
    );
  }
}


class SearchForm extends StatelessWidget {
  const SearchForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
       child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          gradient: LinearGradient(
            colors: [
              Color(0xFFE3DAFF), // Light purple
            Color(0xFFE8E5E5), // Light grayish white
          ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: "University",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Department",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Company",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle search function
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(58, 29, 111, 1),
                minimumSize: const Size(200, 50),
              ),
              child: const Text(
                "Find Now",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      )
    );
  }
}
