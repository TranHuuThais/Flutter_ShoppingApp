import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoppingapp/admin/home_admin.dart';
import 'package:shoppingapp/pages/login.dart';
import 'package:shoppingapp/widget/support_widget.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController usernamecontroller = new TextEditingController();
  TextEditingController userpasswordcontroller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("images/logo.jpg", width: 1000),
                Center(
                  child: Text(
                    " Admin Panel",
                    style: AppWidget.semiBoldTextFeildStyle(),
                  ),
                ),
                const SizedBox(height: 40.0),
                Text("UserName", style: AppWidget.semiBoldTextFeildStyle()),
                const SizedBox(height: 20.0),
                _buildTextField("Usename", usernamecontroller),
                const SizedBox(height: 20.0),
                Text("Email", style: AppWidget.semiBoldTextFeildStyle()),
                const SizedBox(height: 20.0),
                _buildTextField("Password", userpasswordcontroller,
                    obscureText: true),
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
          color: const Color(0xfff4f5f9),
          borderRadius: BorderRadius.circular(20)),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration:
            InputDecoration(border: InputBorder.none, hintText: hintText),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return GestureDetector(
      onTap: () {
        loginAdmin();
      },
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
              color: Colors.green, borderRadius: BorderRadius.circular(10)),
          child: const Center(
              child: Text("LOGIN",
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
      children: [],
    );
  }

  loginAdmin() {
    FirebaseFirestore.instance.collection("Admin").get().then((snapshot) {
      snapshot.docs.forEach((result) {
        if (result.data()['username'] != usernamecontroller.text.trim()) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: const Text(
              "You id is not correct",
              style: TextStyle(fontSize: 20.0),
            )));
        }
        else if(result.data()['password']!=userpasswordcontroller.text.trim()){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: const Text(
              "You password is not correct",
              style: TextStyle(fontSize: 20.0),
            )));
        }
        else{
          Navigator.push(context, MaterialPageRoute(builder: (context)=> HomaAdmin()));
        }
      });
    });
  }
}
