import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonationHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Donation History")),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('donations')
                .orderBy('date', descending: true) // latest first
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final donations = snapshot.data!.docs;

              if (donations.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    // Add some padding around the content
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Option 1: Using a Material Icon
                        Icon(
                          Icons.history_toggle_off_outlined,
                          // Or Icons.bloodtype_outlined, Icons.sentiment_dissatisfied_outlined
                          size: 80.0,
                          color: Colors
                              .grey[400], // Or Theme.of(context).primaryColorLight
                        ),

                        // Option 2: Using an SVG image (add flutter_svg to pubspec.yaml)
                        // Ensure you have an SVG in your assets folder (e.g., assets/images/empty_history.svg)
                        // SvgPicture.asset(
                        //   'assets/images/empty_history.svg',
                        //   height: 120.0,
                        //   colorFilter: ColorFilter.mode(Colors.grey[400]!, BlendMode.srcIn), // Optional: to color the SVG
                        // ),

                        SizedBox(height: 24.0),
                        Text(
                          "No Donations Yet",
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700], // Or a theme color
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          "Once you make a donation, it will appear here. \nReady to save a life?",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 32.0),

                        // Optional: Call to Action Button
                        ElevatedButton.icon(
                          icon: Icon(Icons.add_circle_outline),
                          label: Text("Find Donation Center"),
                          // Or "Learn More"
                          onPressed: () {
                            // TODO: Implement navigation or action
                            // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => FindCenterScreen()));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(
                                  "Navigate to find donation center... (Not Implemented)")),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme
                                .of(context)
                                .colorScheme
                                .primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            textStyle: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }



              return ListView.builder(
                  itemCount: donations.length,
                  itemBuilder: (context, index) {
                    final donation = donations[index];
                    final donorName = donation['donorName'];
                    final bloodGroup = donation['bloodGroup'];
                    final hospital = donation['hospital'];
                    final city = donation['city'];
                    final units = donation['units'];
                    final date = donation['date'].toDate();

                    return Card(
                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                            title: Text("$donorName  •  $bloodGroup"),
                            subtitle: Text(
                                "Hospital: $hospital\nCity: $city\nUnits: $units"),
                            trailing: Text(
                              "${date.toLocal().toString().split(' ')[0]}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                        ),
                    );
                  },
              );
            },
        ),
    );
  }
}
