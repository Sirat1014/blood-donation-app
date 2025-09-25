import 'package:blood_management/donor/donar_list.dart';
import 'package:blood_management/screen/request/blood_request.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../request/all_requests_screen.dart';
import '../chat/chat_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.bloodtype),
        focusColor: Colors.redAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RequestBloodScreen(),
            ),
          );
        },
      ),
      appBar: AppBar(
        title: const Text(
          "BloodBridge Home",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatListScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await auth.logout();
              if (!context.mounted) return;
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(Icons.search),
                      text: "Search Donors",
                    ),
                    Tab(
                      icon: Icon(Icons.list),
                      text: "View Requests",
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                       DonorsListScreen(),
                      AllRequestsScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
