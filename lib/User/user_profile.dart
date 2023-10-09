import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  // Named constructor to create a UserProfile object from a map
  UserProfile.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        email = map['email'],
        phone = map['phone'],
        address = map['address'];

  // Method to convert UserProfile object to Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone':phone,
      'address':address
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
  final _addressController = TextEditingController();
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
        _addressController.text = _userProfile!.address;
      }
    });
  }

  void _saveUserProfile() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text.trim();
      String email = _emailController.text.trim();
      String phone = _phoneController.text.trim();
      String address = _addressController.text.trim();
      await _userService.createUserProfile(name, email,phone,address);

      // Reload the user profile
      _loadUserProfile();
    }
  }

  void registerUser(phone) async{

    String url = "http://192.168.1.115:5000/api/v1/users/register";
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone': phone,
        'role': 'user'
      })
    );

  if(response.statusCode == 201){
    print(response.body);
  }else{
    print(response.body);
  }
 }

 void updateUserData() async{
   String name = _nameController.text.trim();
   String email = _emailController.text.trim();
   String phone = _phoneController.text.trim();
   String address = _addressController.text.trim();

   String url = "http://192.168.1.115:5000/api/v1/users/updateProfile";
   final response = await http.post(
       Uri.parse(url),
       headers: <String, String>{
         'Content-Type': 'application/json; charset=UTF-8',
       },
       body: jsonEncode(<String, String>{
         'phone': phone,
         'email': email,
         'name': name,
         'address': address
       })
   );

   if(response.statusCode == 201){
     print(response.body);
   }else{
     print(response.body);
   }
 }


  @override
  Widget build(BuildContext context) {

    var data = Get.arguments;
    //print(data[0]);
    String phone = data[0].toString();
    _phoneController.text = phone;

    if(phone != null){
      registerUser(phone);
    }

    return Scaffold(
        appBar:AppBar(
          title: const Text('User Profile'),
        ),
        body:SingleChildScrollView(
            child: Container (

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
                      controller: _addressController,
                      decoration: const InputDecoration(
                          label: Text('Address'), prefixIcon: Icon(Icons.place)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: updateUserData,
                      child: Text('Update'),
                    ),
                    SizedBox(height: 20.0),
                    if (_userProfile != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Name: ${_userProfile!.name}'),
                          Text('Email: ${_userProfile!.email}'),
                          Text('Phone: ${_userProfile!.phone}'),
                          Text('Address: ${_userProfile!.address}')
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
            address: userSnapshot['address']
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
          'address':adress
        });
      }
    } catch (e) {
      print(e);
    }
  }
}

