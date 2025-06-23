import 'package:flutter/material.dart';
import 'bottom_navigation.dart';
import 'package:gradbond/models/alumni_model.dart';

class AlumniCard extends StatelessWidget {
  final Alumni alumniData;

  const AlumniCard({super.key, required this.alumniData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: Colors.grey.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 100,
              child: Container(color: const Color(0xFF72428A)),
            ),
            Positioned(
              top: 90,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(color: Colors.white),
            ),
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.topCenter,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    alumniData.profilePicture?.isNotEmpty == true
                        ? alumniData.profilePicture!
                        : 'https://placehold.co/100x100/A020F0/ffffff?text=NP',
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: 140,
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    const SizedBox(height: 8),
                    Text(
                      '${alumniData.university}\n${alumniData.department}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 9,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => print('Follow: ${alumniData.name}'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: const Size(80, 30),
                          ),
                          child: const Text('Follow', style: TextStyle(fontFamily: 'Inter', fontSize: 12)),
                        ),
                        OutlinedButton(
                          onPressed: () => print('Message: ${alumniData.name}'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.deepPurple,
                            side: const BorderSide(color: Colors.deepPurple, width: 1.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: const Size(80, 30),
                          ),
                          child: const Text('Message', style: TextStyle(fontFamily: 'Inter', fontSize: 12)),
                        ),
                      ],
                    )
                  ],
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
  final List<Alumni> alumniList;

  const AlumniListPage({super.key, required this.alumniList});

  @override
  State<AlumniListPage> createState() => _AlumniListPageState();
}

class _AlumniListPageState extends State<AlumniListPage> {
  int _currentPage = 1;
  final int _itemsPerPage = 6;

  List<Alumni> get _pagedAlumni {
    final start = (_currentPage - 1) * _itemsPerPage;
    final end = (_currentPage * _itemsPerPage).clamp(0, widget.alumniList.length);
    return widget.alumniList.sublist(start, end);
  }

  int get _totalPages => (widget.alumniList.length / _itemsPerPage).ceil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.of(context).pop()),
        title: const Text(
          'Alumni List',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.alumniList.isEmpty
                ? const Center(child: Text('No alumni found.'))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.6,
                    ),
                    itemCount: _pagedAlumni.length,
                    itemBuilder: (context, index) {
                      return AlumniCard(alumniData: _pagedAlumni[index]);
                    },
                  ),
          ),
          if (_totalPages > 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                    onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
                  ),
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
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 20),
                    onPressed: _currentPage < _totalPages ? () => setState(() => _currentPage++) : null,
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: bottomNavigation(context: context),
    );
  }
}
