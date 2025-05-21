import 'package:flutter/material.dart';
import 'bottom_navigation.dart';
import 'gradient_bg.dart';

class JobBoardPage extends StatefulWidget {
  const JobBoardPage({super.key});

  @override
  State<JobBoardPage> createState() => _JobBoardPageState();
}

class _JobBoardPageState extends State<JobBoardPage> {
  int currentPage = 1;

  final List<Map<String, String>> jobs = List.generate(
    6,
    (index) => {
      'title': 'Junior Developer',
      'company': 'Therap BD',
      'deadline': '5 May, 2025',
      'salary': '80,000tk',
      'postedBy': 'Akhilakul Islam',
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              const Text(
                'Job Board',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  itemCount: jobs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.95,
                  ),
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF3A1D6F), // dark purple
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            job['title']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            job['company']!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Deadline: ${job['deadline']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Salary: ${job['salary']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Posted By: ${job['postedBy']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 25),
                                ),
                                child: const Text(
                                      'Apply',
                                      style: TextStyle(color: Color(0xFF3A1D6F), fontWeight: FontWeight.bold),
                                    ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 25),
                                ),
                                child: const Text(
                                      'Details',
                                      style: TextStyle(color: Color(0xFF3A1D6F), fontWeight: FontWeight.bold),
                                    ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      setState(() {
                        if (currentPage > 1) currentPage--;
                      });
                    },
                  ),
                  ...List.generate(5, (index) {
                    final pageNumber = index + 1;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentPage = pageNumber;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              currentPage == pageNumber ? Colors.deepPurple : Colors.white,
                          foregroundColor:
                              currentPage == pageNumber ? Colors.white : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        ),
                        child: Text('$pageNumber'),
                      ),
                    );
                  }),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      setState(() {
                        currentPage++;
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigation(context: context),
    );
  }
}
