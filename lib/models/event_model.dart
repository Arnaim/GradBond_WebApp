// Model class for Event
class Event {
  final int id; // Event ID
  final String name; // Event name
  final String description; // Event description/details
  final String date; // Event date
  final String time; // Event time
  final String registrationLink; // Link to register for the event
  final String location; // Event location
  final String imageUrl; // URL of event image/banner
  final String createdBy; // Person who created the event

  // Constructor to initialize Event object
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

  // Create Event object from JSON data
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? 0, // Default to 0 if null
      name: json['name'] ?? 'No Name', // Default to 'No Name'
      description: json['description'] ?? '', // Empty if null
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      registrationLink: json['registration_link'] ?? '',
      location: json['location'] ?? '',
      imageUrl: json['image_url'] ?? '',
      createdBy: json['created_by'] ?? '',
    );
  }
}
