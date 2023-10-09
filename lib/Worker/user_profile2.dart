import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id;
  final String name;
  final String email;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
  });

  // Named constructor to create a UserProfile object from a map
  UserProfile.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        email = map['email'];

  // Method to convert UserProfile object to Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _userService = UserService();
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    UserProfile? userProfile = await _userService.getCurrentUserProfile();
    setState(() {
      _userProfile = userProfile;
      if (_userProfile != null) {
        _nameController.text = _userProfile!.name;
        _emailController.text = _userProfile!.email;
      }
    });
  }

  void _saveUserProfile() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text.trim();
      String email = _emailController.text.trim();

      await _userService.createUserProfile(name, email);

      // Reload the user profile
      _loadUserProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _saveUserProfile,
                child: Text('Save'),
              ),
              SizedBox(height: 20.0),
              if (_userProfile != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('User ID: ${_userProfile!.id}'),
                    Text('Name: ${_userProfile!.name}'),
                    Text('Email: ${_userProfile!.email}'),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserProfile?> getCurrentUserProfile() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();
        return UserProfile(
          id: currentUser.uid,
          name: userSnapshot['name'],
          email: userSnapshot['email'],
        );
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> createUserProfile(String name, String email) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _firestore.collection('users').doc(currentUser.uid).set({
          'id': currentUser.uid,
          'name': name,
          'email': email,
        });
      }
    } catch (e) {
      print(e);
    }
  }
}

