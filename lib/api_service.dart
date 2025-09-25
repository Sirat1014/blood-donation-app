import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000/api';


  // Register User
  static Future<void> registerUser(Map<String, dynamic> data) async {
    var url = Uri.parse('$baseUrl/register');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    print(response.body);
  }

  // Login User
  static Future<void> loginUser(String email, String password) async {
    var url = Uri.parse('$baseUrl/login');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    print(response.body);
  }

  // Create Blood Request
  static Future<void> createBloodRequest(Map<String, dynamic> data) async {
    var url = Uri.parse('$baseUrl/request');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    print(response.body);
  }

  // Get All Blood Requests
  static Future<String> getAllRequests() async {
    var url = Uri.parse('$baseUrl/requests');
    var response = await http.get(url);
    return response.body;
  }


}
