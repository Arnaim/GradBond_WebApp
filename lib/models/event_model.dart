class Event {
  final int id;
  final String name;
  final String description;
  final String date;
  final String time;
  final String registrationLink; // Maps to 'registration_link' in JSON
  final String location;
  final String imageUrl;        // Maps to 'image_url' in JSON
  final String createdBy;       // Maps to 'created_by' in JSON

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.time,
    required this.registrationLink,
    required this.location,
    required this.imageUrl,
    required this.createdBy,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      registrationLink: json['registration_link'] as String, // Note: snake_case
      location: json['location'] as String,
      imageUrl: json['image_url'] as String,                // Note: snake_case
      createdBy: json['created_by'] as String,              // Note: snake_case
    );
  }
}