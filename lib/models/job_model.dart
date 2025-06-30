// models/job_model.dart
class Job {
  final int id; // Job ID
  final int userId; // ID of the user who posted the job
  final String title; // Job title
  final String company; // Company name
  final String jobLink; // Link to apply
  final String jobType; // Type of job (e.g., Full-time, Part-time)
  final String experience; // Experience required
  final String salary; // Salary offered
  final String description; // Job description
  final DateTime deadline; // Application deadline

  // Constructor for Job model
  Job({
    required this.id,
    required this.userId,
    required this.title,
    required this.company,
    required this.jobLink,
    required this.jobType,
    required this.experience,
    required this.salary,
    required this.description,
    required this.deadline,
  });

  // Create Job object from JSON data
  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      company: json['company'],
      jobLink: json['job_link'],
      jobType: json['job_type'],
      experience: json['experience'],
      salary: json['salary'],
      description: json['description'],
      deadline: DateTime.parse(json['deadline']), // Convert string to DateTime
    );
  }
}
