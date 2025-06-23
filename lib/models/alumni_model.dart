class Alumni {
  final int id;
  final String name;
  final String email;
  final String university;
  final String department;
  final String? studentId;
  final int? graduationYear;
  final String company;
  final String jobTitle;
  final String? linkedin;
  final String? profilePicture;

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
      profilePicture: json['Profile Picture'], // Note the space in key name
    );
  }
}