# GradBond - Alumni Finder & Networking Platform

![GradBond Logo](assets/images/logo.png) 

A Flutter-based web application that connects students with alumni through a specialized search system and facilitates networking through events and workshops.

## Features

🔍 **Advanced Alumni Search**  
- Find alumni using specialized filters (graduation year, degree, company, etc.)
- Search by skills, industry, or location

🎯 **Alumni Profiles**  
- Detailed professional profiles
- Career paths and achievements
- Contact information (with privacy controls)

📅 **Events & Workshops**  
- Alumni can create professional events
- Students can discover and join events
- Calendar integration for scheduling

🤝 **Networking Tools**  
- Direct messaging system
- Connection requests
- Mentorship opportunities

## Technologies Used

- **Frontend**: Flutter (Web)
- **Backend**:  django, postgresql, RestAPI
- **State Management**: Provider/Riverpod
- **Search**: Algolia/Firebase Search (custom implementation)
- **Additional Packages**: 
  - intl for date formatting
  - url_launcher for external links
  - cached_network_image for profile pictures
  - fluttertoast for notifications

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Firebase account (for backend services)
- IDE (VS Code or Android Studio recommended)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/gradbond.git
   cd gradbond