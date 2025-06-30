import 'package:flutter/material.dart';
import 'package:gradbond/app_logo.dart';
import 'package:gradbond/home.dart';
import 'package:gradbond/models/job_model.dart';
import 'package:gradbond/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'bottom_navigation.dart';
import 'gradient_bg.dart';
import 'package:intl/intl.dart';

class JobBoardPage extends StatefulWidget {
  const JobBoardPage({super.key});

  @override
  State<JobBoardPage> createState() => _JobBoardPageState();
}

class _JobBoardPageState extends State<JobBoardPage> {
  late Future<List<Job>> _jobListFuture; // Future to load list of jobs asynchronously
  int currentPage = 1; // Current page for pagination, default to 1

  @override
  void initState() {
    super.initState();
    _jobListFuture = ApiService.fetchJobs(); // Initialize job list fetching on page load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend body behind transparent AppBar
      appBar: AppBar(
        title: Text(
                'Job Board',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
        centerTitle: true,
        backgroundColor: Colors.transparent, // Transparent background for AppBar
        elevation: 0, // No shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to HomePage when back icon pressed, replacing current page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        actions: const [
          AppLogo(size: 36), // App logo on the right
        ],
      ),
      body: GradientBackground(
        child: Padding(
          // Padding from top to account for AppBar height and additional spacing
          padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 24, 16, 16),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<List<Job>>(
                  future: _jobListFuture, // Wait for jobs data
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Show loading spinner while fetching jobs
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      // Show error message if fetch failed
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      // Show message if no jobs found
                      return const Center(child: Text('No jobs available.'));
                    }

                    final jobs = snapshot.data!;

                    // GridView to display jobs in 2 columns with spacing and fixed aspect ratio
                    return GridView.builder(
                      itemCount: jobs.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 columns
                        mainAxisSpacing: 12, // vertical spacing between items
                        crossAxisSpacing: 12, // horizontal spacing between items
                        childAspectRatio: 0.75, // width to height ratio for each card
                      ),
                      itemBuilder: (context, index) {
                        final job = jobs[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF3A1D6F), // Deep purple background
                            borderRadius: BorderRadius.circular(16), // Rounded corners
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Job title text styled boldly and white
                              Text(
                                job.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Company name with white70 for slight transparency
                              Text(
                                job.company,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Job deadline formatted using intl package (e.g. Jun 30, 2025)
                              Text(
                                'Deadline: ${DateFormat.yMMMd().format(job.deadline)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              // Salary text with currency indicator
                              Text(
                                'Salary: ${job.salary}tk',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              // Job type (e.g., Full-time, Part-time)
                              Text(
                                'Type: ${job.jobType}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),

                              const Spacer(), // Push the button to the bottom

                              // Row containing the Apply button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      final url = job.jobLink;
                                      // Check if the URL can be launched
                                      if (await canLaunchUrl(Uri.parse(url))) {
                                        // Launch URL externally (browser)
                                        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                                      } else {
                                        // Show snackbar if URL can't be opened
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Could not open the job link")),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                    ),
                                    child: const Text(
                                      'Apply',
                                      style: TextStyle(
                                        color: Color(0xFF3A1D6F),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              // Pagination bar allowing horizontal scrolling and page navigation
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Previous page button
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        setState(() {
                          if (currentPage > 1) currentPage--;
                        });
                      },
                    ),

                    // Generate page number buttons for pages 1 to 5
                    ...List.generate(5, (index) {
                      final pageNumber = index + 1;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              currentPage = pageNumber; // Update to selected page
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: currentPage == pageNumber ? Colors.deepPurple : Colors.white,
                            foregroundColor: currentPage == pageNumber ? Colors.white : Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          ),
                          child: Text('$pageNumber'),
                        ),
                      );
                    }),

                    // Next page button
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        setState(() {
                          currentPage++; // Increment page number
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // Bottom navigation bar shared across pages
      bottomNavigationBar: bottomNavigation(context: context),
    );
  }
}
