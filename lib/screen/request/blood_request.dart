import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum BloodAction { request, donate }

class RequestBloodScreen extends StatefulWidget {
  @override
  _RequestBloodScreenState createState() => _RequestBloodScreenState();
}

class _RequestBloodScreenState extends State<RequestBloodScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedCity;
  String? _selectedBloodGroup;
  String patientName = '';
  String contactNumber = '';
  String hospitalName = '';

  final List<String> _indianCities = [
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Chennai',
    'Kolkata'
  ];

  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  BloodAction? selectedAction = BloodAction.request;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Blood"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Patient Name
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) =>
                value!.isEmpty ? 'Please enter name' : null,
                onSaved: (value) => patientName = value!,
              ),
              SizedBox(height: 16.0),
              // 🏥 Hospital Name
              if(selectedAction == BloodAction.request)
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Hospital Name',
                    prefixIcon: Icon(Icons.local_hospital_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter hospital name'
                      : null,
                  onSaved: (value) => hospitalName = value!,
                ),

              if(selectedAction == BloodAction.request)
                SizedBox(height: 16.0),

              // 🏙️ City Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'City',
                  prefixIcon: Icon(Icons.location_city_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                value: _selectedCity,
                hint: Text('Select City'),
                isExpanded: true,
                items: _indianCities.map((String city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCity = newValue;
                  });
                },
                validator: (value) =>
                value == null ? 'Please select a city' : null,
              ),

              SizedBox(height: 16.0),

              // 🩸 Blood Group Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Blood Group',
                  prefixIcon: Icon(Icons.bloodtype_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                value: _selectedBloodGroup,
                hint: Text('Select Blood Group'),
                isExpanded: true,
                items: _bloodGroups.map((String group) {
                  return DropdownMenuItem<String>(
                    value: group,
                    child: Text(group),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedBloodGroup = newValue;
                  });
                },
                validator: (value) =>
                value == null ? 'Please select a blood group' : null,
              ),

              SizedBox(height: 16.0),

              // 📞 Contact Number
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Contact Number',
                  prefixIcon: Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter contact number';
                  }
                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return 'Enter a valid 10-digit number';
                  }
                  return null;
                },
                onSaved: (value) => contactNumber = value!,
              ),

              SizedBox(height: 24.0),

              // 🔘 Radio buttons
              Text("Action:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              RadioListTile<BloodAction>(
                title: Text('Request Blood'),
                value: BloodAction.request,
                groupValue: selectedAction,
                onChanged: (value) {
                  setState(() {
                    selectedAction = value!;
                  });
                },
                activeColor: Theme.of(context).colorScheme.primary,
              ),
              RadioListTile<BloodAction>(
                title: Text('Register as Donor'),
                value: BloodAction.donate,
                groupValue: selectedAction,
                onChanged: (value) {
                  setState(() {
                    selectedAction = value!;
                  });
                },
                activeColor: Theme.of(context).colorScheme.primary,
              ),

              SizedBox(height: 30.0),

              // ✅ Submit Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  textStyle:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    saveRequestToFirestore();
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveRequestToFirestore() {
    String tableName = selectedAction == BloodAction.request ? 'blood_requests' : 'blood_donors';

    FirebaseFirestore.instance.collection(tableName).add({
      'Name': patientName,
      'bloodGroup': _selectedBloodGroup,
      /*if(selectedAction == BloodAction.request)
        'units': units,*/
      if(selectedAction == BloodAction.request)
        'hospitalName': hospitalName,
      'city': _selectedCity,
      'contactNumber': contactNumber,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Details saved successfully!')),
      );
      _formKey.currentState!.reset();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save record: $error')),
      );
    });
  }
}
