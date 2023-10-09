import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String adress;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.adress,
  });

  // Named constructor to create a UserProfile object from a map
  UserProfile.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        email = map['email'],
        phone = map['phone'],
        adress = map['adress'];

  // Method to convert UserProfile object to Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone':phone,
      'adress':adress
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
  final _phoneController = TextEditingController();
  final _adressController = TextEditingController();
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
        _phoneController.text = _userProfile!.phone;
        _adressController.text = _userProfile!.adress;
      }
    });
  }

  void _saveUserProfile() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text.trim();
      String email = _emailController.text.trim();
      String phone = _phoneController.text.trim();
      String adress = _adressController.text.trim();
      await _userService.createUserProfile(name, email,phone,adress);

      // Reload the user profile
      _loadUserProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
          title: Text('User Profile'),
        ),
        body:SingleChildScrollView(child:Container (

            child:Padding( padding:const EdgeInsets.all(20.0),
              child:Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                          label: Text('FullName'),
                          prefixIcon: Icon(Icons.person_outline_rounded)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height:  20),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                          label: Text('Email'), prefixIcon: Icon(Icons.email_outlined)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                          label: Text('PhoneNo'), prefixIcon: Icon(Icons.numbers)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your Phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height:20),
                    TextFormField(
                      controller: _adressController,
                      decoration: const InputDecoration(
                          label: Text('Adress'), prefixIcon: Icon(Icons.place)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your adress';
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
                          Text('Name: ${_userProfile!.name}'),
                          Text('Email: ${_userProfile!.email}'),
                          Text('Phone: ${_userProfile!.phone}'),
                          Text('Adress: ${_userProfile!.adress}')
                        ],
                      ),
                  ],
                ),
              ),
            )))
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
            phone:userSnapshot['phone'],
            adress: userSnapshot['adress']
        );
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> createUserProfile(String name, String email,String phone,String adress) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _firestore.collection('users').doc(currentUser.uid).set({
          'id': currentUser.uid,
          'name': name,
          'email': email,
          'phone':phone,
          'adress':adress
        });
      }
    } catch (e) {
      print(e);
    }
  }
}

