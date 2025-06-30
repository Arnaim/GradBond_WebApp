import 'package:flutter/material.dart';
import 'package:gradbond/app_logo.dart';
import 'package:gradbond/home.dart';
import 'bottom_navigation.dart';
import 'alumni_list.dart';
import '/services/api_service.dart';
import 'package:gradbond/services/storage/storage_service.dart';

class FindAlumni extends StatelessWidget {
  const FindAlumni({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Body extends behind transparent app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent app bar
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to HomePage on back button press
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        actions: const [
          AppLogo(size: 36), // Show app logo on app bar
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE3DAFF), // Light purple gradient start
              Color(0xFFE8E5E5), // Light grayish white gradient end
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
            children: const [
              Text(
                "Find Alumni of your University",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 20), // Spacing between text and form
              SearchForm(), // The search form widget
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigation(context: context), // Bottom nav bar
    );
  }
}

class SearchForm extends StatefulWidget {
  const SearchForm({super.key});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  // Controllers for input fields
  final _universityController = TextEditingController();
  final _departmentController = TextEditingController();
  final _companyController = TextEditingController();
  final _jobTitleController = TextEditingController();

  bool _isLoading = false; // Loading state to show progress indicator

  // Function to find alumni using API call
  Future<void> _findAlumni() async {
    setState(() => _isLoading = true); // Show loading spinner

    try {
      final token = await StorageService.getToken(); // Get saved auth token

      if (token == null) {
        // Show error if user not logged in
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to search')),
        );
        setState(() => _isLoading = false);
        return;
      }

      // Call API to find alumni based on input criteria
      final alumniList = await ApiService.findAlumni(
        university: _universityController.text.trim(),
        department: _departmentController.text.trim(),
        company: _companyController.text.trim(),
        jobTitle: _jobTitleController.text.trim(),
      );

      if (alumniList.isEmpty) {
        // Show message if no alumni found
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No alumni found')),
        );
      } else {
        // Navigate to AlumniListPage to show results
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlumniListPage(alumniList: alumniList),
          ),
        );
      }
    } catch (e) {
      // Show error message on exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch alumni: $e')),
      );
    } finally {
      setState(() => _isLoading = false); // Hide loading spinner
    }
  }

  @override
  void dispose() {
    // Dispose controllers to free resources
    _universityController.dispose();
    _departmentController.dispose();
    _companyController.dispose();
    _jobTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Slight shadow around card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Rounded corners
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Color(0xFFE3DAFF), Color(0xFFE8E5E5)], // Gradient background
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Input field for University
              TextFormField(
                controller: _universityController,
                decoration: const InputDecoration(
                  labelText: "University",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16), // Spacing

              // Input field for Department
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(
                  labelText: "Department",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Input field for Company
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(
                  labelText: "Company",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Input field for Job Title
              TextFormField(
                controller: _jobTitleController,
                decoration: const InputDecoration(
                  labelText: "Job Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Show loading spinner or Find Now button
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _findAlumni, // Trigger search on press
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(58, 29, 111, 1), // Button color
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
      ),
    );
  }
}
