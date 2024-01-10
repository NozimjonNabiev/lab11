import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  late String email;
  late String password;
  late String fullName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Icon(
                    Icons.account_circle,
                    size: 100.0,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    email = value!.trim();
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    password = value!.trim();
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter your full name',
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    fullName = value!.trim();
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      try {
                        final UserCredential userCredential =
                            await _auth.createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        if (userCredential.user != null) {
                          await _firestore
                              .collection('users')
                              .doc(userCredential.user!.uid)
                              .set({
                            'email': email,
                            'fullName': fullName,
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Registration Successful'),
                              duration: Duration(seconds: 2),
                            ),
                          );

                          Future.delayed(Duration(seconds: 2), () {
                            Navigator.pushReplacementNamed(
                                context, LoginScreen.id);
                          });
                        }
                      } catch (e) {
                        print('Registration failed: $e');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('Register'),
                ),
                SizedBox(height: 20.0),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Already have an account? Sign in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
