import 'package:flutter/material.dart';
import 'package:gradbond/app_logo.dart';
import 'bottom_navigation.dart';
import 'package:gradbond/models/alumni_model.dart';
import 'publicAlumniProfilePage .dart';

class AlumniCard extends StatelessWidget {
  final Alumni alumniData;

  const AlumniCard({super.key, required this.alumniData});

  @override
  Widget build(BuildContext context) {
    // Displays single alumni card UI with gradient background and info
    return GradientBackground(alumniData: alumniData);
  }
}

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
    required this.alumniData,
  });

  final Alumni alumniData;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: Colors.grey.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Top banner with profile picture
            Stack(
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  color: const Color(0xFF72428A),
                ),
                Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        // Show profile pic or placeholder if none
                        alumniData.profilePicture?.isNotEmpty == true
                            ? alumniData.profilePicture!
                            : 'https://placehold.co/100x100/A020F0/ffffff?text=NP',
                      ),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            // Alumni info: name, job title, company, university & department
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      alumniData.name,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      alumniData.jobTitle,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      alumniData.company,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${alumniData.university}\n${alumniData.department}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 9,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Button to navigate to detailed public alumni profile page
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PublicAlumniProfilePage(alumni: alumniData),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: const Size(100, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'About Me',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlumniListPage extends StatefulWidget {
  final List<Alumni> alumniList; // List of alumni to display

  const AlumniListPage({super.key, required this.alumniList});

  @override
  State<AlumniListPage> createState() => _AlumniListPageState();
}

class _AlumniListPageState extends State<AlumniListPage> {
  int _currentPage = 1; // Current page in pagination
  final int _itemsPerPage = 6; // Number of cards per page

  // Return the alumni for the current page only
  List<Alumni> get _pagedAlumni {
    final start = (_currentPage - 1) * _itemsPerPage;
    final end = (_currentPage * _itemsPerPage).clamp(0, widget.alumniList.length);
    return widget.alumniList.sublist(start, end);
  }

  // Calculate total pages based on alumni count and items per page
  int get _totalPages => (widget.alumniList.length / _itemsPerPage).ceil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(onPressed: () => Navigator.of(context).pop()), // Back button
        title: const Text(
          'Alumni List',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        actions: const [
          AppLogo(size: 36), // App logo on top right
        ],
      ),

      body: Column(
        children: [
          const SizedBox(height: 30),

          // Main content: grid of alumni cards or 'no alumni' message
          Expanded(
            child: widget.alumniList.isEmpty
                ? const Center(child: Text('No alumni found.'))
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 24, 16, 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.6,
                    ),
                    itemCount: _pagedAlumni.length,
                    itemBuilder: (context, index) {
                      // Show each alumni card from current page data
                      return AlumniCard(alumniData: _pagedAlumni[index]);
                    },
                  ),
          ),

          // Pagination controls shown only if more than one page
          if (_totalPages > 1)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Previous page button
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 20),
                      onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
                    ),

                    // Page number buttons with highlighting for current page
                    ...List.generate(_totalPages, (index) {
                      final page = index + 1;
                      final isSelected = page == _currentPage;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                          onTap: () => setState(() => _currentPage = page),
                          child: Container(
                            width: 32,
                            height: 32,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.deepPurple : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected ? Colors.deepPurple : Colors.grey.shade400,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '$page',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),

                    // Next page button
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 20),
                      onPressed: _currentPage < _totalPages ? () => setState(() => _currentPage++) : null,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),

      bottomNavigationBar: bottomNavigation(context: context), // Bottom nav bar shared across app
    );
  }
}
