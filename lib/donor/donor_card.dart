import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screen/chat/chat_screen.dart';
import '../services/chat_service.dart';


class DonorCard extends StatelessWidget {
  // final Donor donor; // Assuming you pass a Donor object
  final String donorName;
  final String bloodGroup;
  final String city;
  final String contact;
  final DateTime lastDonationDate;
  final bool isRequest;
  final String donorUid;

  const DonorCard({
    Key? key,
    required this.donorUid,
    required this.donorName,
    required this.bloodGroup,
    required this.city,
    required this.contact,
    required this.lastDonationDate, required this.isRequest,
  }) : super(key: key);

  @override Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMM dd, yyyy').format(
        lastDonationDate); // Example formatting

    return InkWell(
        onTap: () async {
          final currentUid = FirebaseAuth.instance.currentUser!.uid;

          final chatId = buildChatId(currentUid, donorUid);
          await createOrGetChatDoc(chatId, currentUid, donorUid);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatScreen(
                chatId: chatId,
                otherUid: donorUid,
                otherName: donorName,
              ),
            ),
          );
        },
        child: Card(
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
                Text(isRequest ? "Request Date: " : "Last Donation: "),
                Text(formattedDate,
                    style: TextStyle(fontStyle: FontStyle.italic)),
              ],
            ),
          ],
        ),
      ),
    ),
    );
  }
}
