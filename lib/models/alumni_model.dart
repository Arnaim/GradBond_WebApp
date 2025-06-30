// Model class for Alumni
class Alumni {
  final int id; // Alumni ID
  final String name; // Alumni name
  final String email; // Alumni email
  final String university; // University name
  final String department; // Department name
  final String? studentId; // Optional student ID
  final int? graduationYear; // Optional graduation year
  final String company; // Company name
  final String jobTitle; // Job title
  final String? linkedin; // Optional LinkedIn link
  final String? profilePicture; // Optional profile picture

  // Constructor for Alumni model
  Alumni({
    required this.id,
    required this.name,
    required this.email,
    required this.university,
    required this.department,
    this.studentId,
    this.graduationYear,
    required this.company,
    required this.jobTitle,
    this.linkedin,
    this.profilePicture,
  });

  // Create Alumni object from JSON data
  factory Alumni.fromJson(Map<String, dynamic> json) {
    return Alumni(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      university: json['university'],
      department: json['department'],
      studentId: json['studentId'],
      graduationYear: json['graduationYear'],
      company: json['company'],
      jobTitle: json['jobTitle'],
      linkedin: json['linkedin'],
      profilePicture: json['Profile Picture'], // Key has space in it
    );
  }
}
