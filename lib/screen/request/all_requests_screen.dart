import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../api_service.dart';
import 'dart:convert';

import '../../donor/donor_card.dart';

class AllRequestsScreen extends StatefulWidget {
  const AllRequestsScreen({super.key});

  @override
  _AllRequestsScreenState createState() => _AllRequestsScreenState();
}

class _AllRequestsScreenState extends State<AllRequestsScreen> {
  List requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    //fetchRequests(); // if you want to fetch from API instead of Firestore
  }

  Future<void> fetchRequests() async {
    var response = await ApiService.getAllRequests(); // make sure it returns response.body
    setState(() {
      requests = jsonDecode(response); // convert JSON string to List
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('blood_requests')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final donors = snapshot.data!.docs;

          if (donors.isEmpty) {
            return const Center(child: Text("No donors registered yet."));
          }

          return ListView.builder(
            itemCount: donors.length,
            itemBuilder: (context, index) {
              final donor = donors[index];
              final data = donor.data() as Map<String, dynamic>;

              return DonorCard(
                donorUid: donor.id, // ✅ FIXED (required parameter)
                isRequest: true,
                donorName: data['Name'] ?? 'Unknown',
                bloodGroup: data['bloodGroup'] ?? 'N/A',
                city: data['city'] ?? 'N/A',
                contact: data['contactNumber'] ?? 'N/A',
                lastDonationDate: (data['timestamp'] as Timestamp?)?.toDate() ??
                    DateTime.now(),
              );
            },
          );
        },
      ),
    );
  }
}
