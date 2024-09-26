import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoppingapp/pages/bottomnav.dart';
import 'package:shoppingapp/pages/login.dart';
import 'package:shoppingapp/widget/support_widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? name, email, password;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registration() async {
    if (email != null && name != null && password != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email!, password: password!);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: const Text(
              "Registered Successfully",
              style: TextStyle(fontSize: 20.0),
            )));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Bottomnav()));
      } on FirebaseException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.redAccent,
              content: const Text(
                "Password provided is too weak",
                style: TextStyle(fontSize: 20.0),
              )));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.redAccent,
              content: const Text(
                "Account already exists",
                style: TextStyle(fontSize: 20.0),
              )));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                "An error occurred: ${e.message}",
                style: const TextStyle(fontSize: 20.0),
              )));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("images/logo.jpg", width: 1000),
                Center(
                  child: Text(
                    "Sign Up",
                    style: AppWidget.semiBoldTextFeildStyle(),
                  ),
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: Text(
                    "Please enter the details below to\n                      continue.",
                    style: AppWidget.LightTextFeildStyle(),
                  ),
                ),
                const SizedBox(height: 40.0),
                Text("Name", style: AppWidget.semiBoldTextFeildStyle()),
                const SizedBox(height: 20.0),
                _buildTextField("Name", namecontroller),
                const SizedBox(height: 20.0),
                Text("Email", style: AppWidget.semiBoldTextFeildStyle()),
                const SizedBox(height: 20.0),
                _buildTextField("Email", emailcontroller),
                const SizedBox(height: 20.0),
                Text("Password", style: AppWidget.semiBoldTextFeildStyle()),
                const SizedBox(height: 20.0),
                _buildTextField("Password", passwordcontroller, obscureText: true),
                const SizedBox(height: 50.0),
                _buildSignUpButton(),
                const SizedBox(height: 20.0),
                _buildSignInLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller,
      {bool obscureText = false}) {
    return Container(
      padding: const EdgeInsets.only(left: 20.0),
      decoration: BoxDecoration(
          color: const Color(0xfff4f5f9), borderRadius: BorderRadius.circular(20)),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $hintText';
          }
          return null;
        },
        decoration: InputDecoration(border: InputBorder.none, hintText: hintText),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return GestureDetector(
      onTap: () {
        if (_formkey.currentState!.validate()) {
          setState(() {
            name = namecontroller.text;
            email = emailcontroller.text;
            password = passwordcontroller.text;
          });
          registration();
        }
      },
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
              color: Colors.green, borderRadius: BorderRadius.circular(10)),
          child: const Center(
              child: Text("SIGN UP",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold))),
        ),
      ),
    );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an account? ", style: AppWidget.LightTextFeildStyle()),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Login()));
          },
          child: const Text("Sign In",
              style: TextStyle(
                  color: Colors.green, fontSize: 18.0, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}
