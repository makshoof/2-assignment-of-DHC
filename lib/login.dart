import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/home.dart';
import 'package:myapp/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn googleSignIn = GoogleSignIn();

  // Future<void> signInWithGoogle() async {
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
  //       print(credential);
  //       print("credential");
  //       final UserCredential userCredential =
  //           await _auth.signInWithCredential(credential);
  //       print(userCredential);
  //       print("userCredential");
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Logged in successfully with Google!'),
  //         ),
  //       );

  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => Mainscreen()),
  //       );
  //     }
  //   } catch (error) {
  //     print('Error signing in with Google: $error');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Failed to sign in with Google. Please try again.'),
  //       ),
  //     );
  //   }
  // }

  String emailError = ''; // Declare emailError here
  String passwordError = '';
  bool passwordVisible = false;

  bool validateAndSave() {
    bool isValid = true;

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

    return isValid;
  }

  void togglePasswordVisibility() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  Future<void> loginWithFirebase() async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      String email = emailController.text;
      String password = passwordController.text;

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final _db = FirebaseFirestore.instance;
      final sanpshot = await _db.collection('users').get();
      print(sanpshot);
      print(sanpshot.docs.map((e) {
        print(e.data());
        if (e.data()['email'] == emailController.text) {
          dynamic userDetails = {
            "name": e.data()["name"],
            "email": e.data()["email"],
            "role": e.data()["role"],
            "gender": e.data()["gender"],
          };
          _pref.setString('userDetails', json.encode(userDetails));
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ));
        }
      }));

    

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Successful!'),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Incorrect Email or Password.'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        print("FirebaseAuthException: $e");
      }
    } catch (e) {
      print("Exception caught: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 150,
                ),
                Text(
                  'Sign In',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 45,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 115,
                ),
                Text(
                  'Hi Welcome back!',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
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
                          SizedBox(
                            height: 30,
                          ),
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
                            height: 20,
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
                              hintText: "***************",
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {
                                  },
                                  child: Text(
                                    'Forget password?',
                                    style: TextStyle(color: Colors.blue),
                                  )),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ConstrainedBox(
                                constraints:
                                    BoxConstraints.tightFor(width: 350),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    if (validateAndSave()) {
                                      loginWithFirebase();
                                    }
                                  },
                                  label: Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
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
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     GestureDetector(
                    //       onTap: signInWithGoogle,
                    //       child: Image.asset(
                    //         './assets/th.png',
                    //         height: 60,
                    //         width: 60,
                    //       ),
                    //     )
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Signup()));
                  },
                  child: Text(
                    'Sign Up',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                    ),
                  ),
                  style: ButtonStyle(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
