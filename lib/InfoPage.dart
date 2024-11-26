import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  // Function to launch phone dialer
  void _launchDialer(String phoneNumber) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildInfoSectionWithIcon(
                  title: 'Özgür EKER',
                  content: ['0533 141 21 21', '0532 412 97 44'],
                ),
                const SizedBox(height: 12.0), // Reduced the vertical spacing
                _buildInfoSectionWithIcon(
                  title: 'Sabit Hat:',
                  content: ['0326 613 38 42', '0326 613 65 91'],
                ),
                const SizedBox(height: 12.0), // Reduced the vertical spacing
                _buildInfoSection(
                  title: 'Adres:',
                  content: 'Şehit Pamir Caddesi No:15\nİSKENDERUN',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget to build sections with clickable phone numbers and phone icons
  Widget _buildInfoSectionWithIcon({
    required String title,
    required List<String> content,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Adjusted padding
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.black12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.phone, size: 20.0), // Added phone icon
          const SizedBox(width: 8.0), // Space between icon and text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20, // Increased font size for title
                  ),
                ),
                const SizedBox(height: 6.0), // Adjusted space between title and content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: content
                      .map((phoneNumber) => GestureDetector(
                    onTap: () => _launchDialer(phoneNumber),
                    child: Text(
                      phoneNumber,
                      style: const TextStyle(
                        color: Colors.blue, // Styled as clickable
                        fontSize: 16, // Increased font size for content
                        decoration: TextDecoration.underline, // Underlined for emphasis
                      ),
                    ),
                  ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget to build sections without phone numbers
  Widget _buildInfoSection({
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Adjusted padding
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.black12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20, // Increased font size for title
            ),
          ),
          const SizedBox(height: 6.0), // Adjusted space between title and content
          Text(
            content,
            style: const TextStyle(fontSize: 16), // Increased font size for content
          ),
        ],
      ),
    );
  }
}
