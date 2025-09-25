import 'package:flutter/material.dart';

class RequestBloodScreen extends StatefulWidget { // Convert to StatefulWidget for Form key
  @override
  _RequestBloodScreenState createState() => _RequestBloodScreenState();
}

class _RequestBloodScreenState extends State<RequestBloodScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBloodGroup;
  int _requestOrDonate = 0;
  // 0 for Request, 1 for Donate

  // Dummy blood group list
  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xFFC62828);
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Blood"),
        elevation: 1, // Subtle shadow
      ),
      body: SingleChildScrollView( // Allows scrolling if content overflows
        padding: EdgeInsets.all(20.0), // Overall padding
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Make button stretch
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Patient Name',
                  hintText: 'Enter full name',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the patient\'s name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
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
                items: _bloodGroups.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedBloodGroup = newValue;
                  });
                },
                validator: (value) => value == null ? 'Please select a blood group' : null,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Units Required',
                  hintText: 'e.g., 2',
                  prefixIcon: Icon(Icons.format_list_numbered_rtl_outlined), // Or a custom one
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter units required';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid number of units';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Hospital Name',
                  prefixIcon: Icon(Icons.local_hospital_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter hospital name' : null,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'City',
                  prefixIcon: Icon(Icons.location_city_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter city' : null,
              ),
              SizedBox(height: 16.0),
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
                  // Add more specific phone validation if needed
                  return null;
                },
              ),
              SizedBox(height: 24.0), // More space before radio buttons
              Text("Action:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              RadioListTile<int>(
                title: Text('Request Blood'),
                value: 0,
                groupValue: _requestOrDonate,
                onChanged: (int? value) {
                  setState(() {
                    _requestOrDonate = value!;
                  });
                },
                activeColor: Theme.of(context).colorScheme.primary,
              ),
              RadioListTile<int>(
                title: Text('Register as Donor (Placeholder)'), // Assuming this form is primarily for requesting
                value: 1,
                groupValue: _requestOrDonate,
                onChanged: (int? value) {
                  setState(() {
                    _requestOrDonate = value!;
                  });
                },
                activeColor: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Form is valid, process the data
                    print('Form submitted');
                    print('Name: ..., Blood Group: $_selectedBloodGroup, Type: $_requestOrDonate');
                    // Add your submission logic here
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
}
