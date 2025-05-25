// models/job_model.dart
class Job {
  final int id;
  final int userId;
  final String title;
  final String company;
  final String jobLink;
  final String jobType;
  final String experience;
  final String salary;
  final String description;
  final DateTime deadline;

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
      deadline: DateTime.parse(json['deadline']),
    );
  }
}
