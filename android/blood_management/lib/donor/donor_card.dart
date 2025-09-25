import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

// ... (Assuming you have a Donor data model)
// class Donor {
//   final String name;
//   final String bloodGroup;
//   final String city;
//   final String contact;
//   final DateTime lastDonation;
//
//   Donor({
//     required this.name,
//     required this.bloodGroup,
//     required this.city,
//     required this.contact,
//     required this.lastDonation,
//   });
// }

class DonorCard extends StatelessWidget {
  // final Donor donor; // Assuming you pass a Donor object
  final String donorName;
  final String bloodGroup;
  final String city;
  final String contact;
  final DateTime lastDonationDate;

  const DonorCard({
    Key? key,
    required this.donorName,
    required this.bloodGroup,
    required this.city,
    required this.contact,
    required this.lastDonationDate,
  }) : super(key: key);

  @override Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMM dd, yyyy').format(
        lastDonationDate); // Example formatting

    return Card(
      elevation: 2.0, // Slight elevation
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              donorName,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Theme
                    .of(context)
                    .primaryColorDark, // Or a suitable color
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Icon(Icons.bloodtype, size: 16.0, color: Colors.red[700]),
                SizedBox(width: 8.0),
                Text("Blood Group: "),
                Text(bloodGroup, style: TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            SizedBox(height: 6.0),
            Row(
              children: [
                Icon(Icons.location_city, size: 16.0, color: Colors.grey[700]),
                SizedBox(width: 8.0),
                Text("City: "),
                Text(city),
              ],
            ),
            SizedBox(height: 6.0),
            Row(
              children: [
                Icon(Icons.phone, size: 16.0, color: Colors.blue[700]),
                SizedBox(width: 8.0),
                Text("Contact: "),
                Text(contact),
                Spacer(), // Pushes the call icon to the end
                IconButton(
                  icon: Icon(Icons.call_outlined, color: Theme
                      .of(context)
                      .colorScheme
                      .secondary),
                  onPressed: () {
                    // Implement call functionality
                    print("Calling $contact");
                  },
                  tooltip: "Call $donorName",
                )
              ],
            ),
            SizedBox(height: 6.0),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16.0, color: Colors.grey[700]),
                SizedBox(width: 8.0),
                Text("Last Donation: "),
                Text(formattedDate,
                    style: TextStyle(fontStyle: FontStyle.italic)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
