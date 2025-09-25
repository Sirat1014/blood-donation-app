import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'donor_card.dart';

class DonorsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('blood_donors').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final donors = snapshot.data!.docs;

          if (donors.isEmpty) {
            return Center(child: Text("No donors registered yet."));
          }
          return ListView.builder(
            itemCount: donors.length,
            itemBuilder: (context, index) {
              final donor = donors[index];
              return DonorCard(
                isRequest: false,
                donorName: donor['Name'], // Adjust based on your data structure
                bloodGroup: donor['bloodGroup'],
                city: donor['city'],
                contact: donor['contactNumber'],
                lastDonationDate: (donor['timestamp'] as Timestamp).toDate(), donorUid: '', // Example if from Firestore
              );
            },
          );
        },
      ),
    );
  }
}
