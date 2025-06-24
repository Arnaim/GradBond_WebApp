import 'package:flutter/material.dart';
import 'package:gradbond/gradient_bg.dart';
import 'bottom_navigation.dart';
import 'alumni_list.dart';
// Import Alumni model
import '/services/api_service.dart';
import 'package:gradbond/services/storage/storage_service.dart';

class FindAlumni extends StatelessWidget {
  const FindAlumni({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Find Alumni of your University",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 20),
              SearchForm(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigation(context: context),
    );
  }
}

class SearchForm extends StatefulWidget {
  const SearchForm({super.key});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _universityController = TextEditingController();
  final _departmentController = TextEditingController();
  final _companyController = TextEditingController();
  final _jobTitleController = TextEditingController();

  bool _isLoading = false;

  //find alumni function using api

  void _findAlumni() async {
  setState(() => _isLoading = true);

  try {
    final token = await StorageService.getToken();

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to search')),
      );
      setState(() => _isLoading = false);
      return;
    }

    final alumniList = await ApiService.findAlumni(
      university: _universityController.text.trim(),
      department: _departmentController.text.trim(),
      company: _companyController.text.trim(),
      jobTitle: _jobTitleController.text.trim(),
    );

    if (alumniList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No alumni found')),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AlumniListPage(alumniList: alumniList),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to fetch alumni: $e')),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}



  @override
  void dispose() {
    _universityController.dispose();
    _departmentController.dispose();
    _companyController.dispose();
    _jobTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Color(0xFFE3DAFF), Color(0xFFE8E5E5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _universityController,
                decoration: const InputDecoration(
                  labelText: "University",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(
                  labelText: "Department",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(
                  labelText: "Company",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jobTitleController,
                decoration: const InputDecoration(
                  labelText: "Job Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _findAlumni,
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
      ),
    );
  }
}