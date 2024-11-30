import 'package:flutter/material.dart';
import 'package:trova/api_service.dart';
import 'package:trova/class/image_location.dart';
import 'package:trova/class/user_class.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../auth/login_page.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final UserClass userClass = UserClass();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    try {
      await userClass.fetchUser();
      setState(() {
        nameController.text = userClass.name ?? '';
        contactController.text = '';
        addressController.text = '';
        isLoading = false;
      });
    } catch (e) {
      print("Error loading user details: $e");
    }
  }

  // Save user details
  Future<void> _saveChanges() async {
    final updatedData = {
      'name': nameController.text,
      'contact': contactController.text,
      'address': addressController.text,
    };

    try {
      final response = await http.put(
        Uri.parse('http://172.20.10.4/api/users/update'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'accessToken=${userClass.authToken}',
        },
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        print("User details updated successfully.");
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')));
      } else {
        print("Failed to update user details: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update profile')));
      }
    } catch (e) {
      print("Error while saving changes: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error while updating profile')));
    }
  }

  // Logout function
  Future<void> _logout() async {
    try {
      final response = await http.get(
        Uri.parse('http://172.20.10.4/api/users/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'accessToken=${userClass.authToken}',
        },
      );

      if (response.statusCode == 200) {
        print("User logged out successfully.");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        print("Failed to log out: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during logout: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: userClass.profilepic != null
                          ? NetworkImage(
                          ImageLocation()
                              .imageUrl(userClass.profilepic.toString()))
                          : null,
                      child: userClass.profilepic == null
                          ? const Icon(Icons.person,
                          size: 50, color: Colors.white)
                          : null,
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: InkWell(
                        onTap: () {},
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF238688),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(5.0),
                          child: const Icon(Icons.camera_alt,
                              color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: userClass.userName),
                decoration: const InputDecoration(
                  labelText: 'User name',
                  border: UnderlineInputBorder(),
                ),
                enabled: false,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: userClass.useremail),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: UnderlineInputBorder(),
                ),
                enabled: false,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contactController,
                decoration: const InputDecoration(
                  labelText: 'Contact number',
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: _saveChanges,
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF238688),
                      ),
                    ),
                  ),
                  const SizedBox(height: 1),
                  TextButton(
                    onPressed: _logout,
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 1),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Delete Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
