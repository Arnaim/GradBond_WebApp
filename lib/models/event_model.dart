class Event {
  final int id;
  final String name;
  final String description;
  final String date;
  final String time;
  final String registrationLink; 
  final String location;
  final String imageUrl;          
  final String createdBy;         

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
      id: json['id'] ?? 0,
      name: json['name'] ?? 'No Name',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      registrationLink: json['registration_link'] ?? '',
      location: json['location'] ?? '',
      imageUrl: json['image_url'] ?? '',
      createdBy: json['created_by'] ?? '',
    );
  }
}