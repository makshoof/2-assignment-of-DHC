import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/login.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Future<void> signUpWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleSignInAccount =
  //         await googleSignIn.signIn();
  //     if (googleSignInAccount != null) {
  //       final GoogleSignInAuthentication googleSignInAuthentication =
  //           await googleSignInAccount.authentication;

  //       final AuthCredential credential = GoogleAuthProvider.credential(
  //         accessToken: googleSignInAuthentication.accessToken,
  //         idToken: googleSignInAuthentication.idToken,
  //       );

  //       final UserCredential userCredential =
  //           await _auth.signInWithCredential(credential);

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Signed up successfully with Google!'),
  //         ),
  //       );
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => Login()),
  //       );
  //       // Navigate to home screen or any other page
  //       // Navigator.pushReplacement(
  //       //   context,
  //       //   MaterialPageRoute(builder: (context) => Home()),
  //       // );
  //     }
  //   } catch (error) {
  //     print('Error signing up with Google: $error');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Failed to sign up with Google. Please try again.'),
  //       ),
  //     );
  //   }
  // }

  sendDataToFireStore() async {
    final _db = FirebaseFirestore.instance;

    final dataList = {
      "email": emailController.text,
      "password": passwordController.text,
      "name": fullNameController.text,
      "gender": "male",
      "role": "user",
      "time": DateTime.now().toString()
    };

    await _db.collection("users").add(dataList).whenComplete(() {
      print("SuccessFully Submitted");
      emailController.clear();
      passwordController.clear();
    });
  }

  String fullNameError = '';
  String emailError = '';
  String passwordError = '';
  String confirmPasswordError = '';

  bool passwordVisible = false;
  bool showSuccessMessage = false;

  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  void togglePasswordVisibility() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  bool validateAndSave() {
    bool isValid = true;

    if (fullNameController.text.isEmpty) {
      setState(() {
        fullNameError = 'Please enter your full Name';
      });
      isValid = false;
    } else {
      setState(() {
        fullNameError = '';
      });
    }

    if (emailController.text.isEmpty) {
      setState(() {
        emailError = 'Please enter your email';
      });
      isValid = false;
    } else {
      setState(() {
        emailError = '';
      });
    }

    if (passwordController.text.isEmpty) {
      setState(() {
        passwordError = 'Please enter your password';
      });
      isValid = false;
    } else {
      setState(() {
        passwordError = '';
      });
    }

    if (confirmPasswordController.text.isEmpty) {
      setState(() {
        confirmPasswordError = 'Please confirm your password';
      });
      isValid = false;
    } else if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        confirmPasswordError = 'Password does not match';
      });
      isValid = false;
    } else {
      setState(() {
        confirmPasswordError = '';
      });
    }

    return isValid;
  }

  Future<void> signUp() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      sendDataToFireStore();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully account created!'),
          duration: Duration(seconds: 2),
        ),
      );

      // Move to another screen after successful registration
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration failed. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Create Account!',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 33,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Fill your information below or register',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'With your social account',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Name',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: fullNameController,
                            style: TextStyle(color: Colors.black),
                            onChanged: (value) {
                              setState(() {
                                fullNameError = '';
                              });
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "Jhon Doe",
                              hintStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                'Email',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: emailController,
                            style: TextStyle(color: Colors.black),
                            onChanged: (value) {
                              setState(() {
                                emailError = '';
                              });
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "example@gmail.com",
                              hintStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                'Password',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: passwordController,
                            style: TextStyle(color: Colors.black),
                            onChanged: (value) {
                              setState(() {
                                passwordError = '';
                              });
                            },
                            obscureText: !passwordVisible,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "************",
                              hintStyle: TextStyle(color: Colors.black),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black,
                                ),
                                onPressed: togglePasswordVisibility,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                'Confirm Password',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: confirmPasswordController,
                            style: TextStyle(color: Colors.black),
                            onChanged: (value) {
                              setState(() {
                                confirmPasswordError = '';
                              });
                            },
                            obscureText: !passwordVisible,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "************",
                              hintStyle: TextStyle(color: Colors.black),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black,
                                ),
                                onPressed: togglePasswordVisibility,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text('Agree with '),
                              Text(
                                'Term & Conditions',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ConstrainedBox(
                                constraints:
                                    BoxConstraints.tightFor(width: 350),
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    if (validateAndSave()) {
                                      await signUp();
                                    }
                                  },
                                  label: Text('Sign Up',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.cyan.shade800,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10.0), // Adjust the radius as needed
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Divider(
                          thickness: 5,
                          color: Colors.black,
                        )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Expanded(
                            child: Divider(
                          thickness: 5,
                          color: Colors.black,
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ));
                          },
                          child: Text(
                            'Login',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                            ),
                          ),
                          style: ButtonStyle(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
