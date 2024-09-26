import 'package:flutter/material.dart';
import 'package:shoppingapp/pages/login.dart';
import 'package:shoppingapp/widget/support_widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin:
              EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("images/images.jpg", width: 1000),
              Center(
                child: Center(
                  child: Text(
                    "Sign Up",
                    style: AppWidget.semiBoldTextFeildStyle(),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Center(
                child: Text(
                  "Please enter the details below to\n                      continue.",
                  style: AppWidget.LightTextFeildStyle(),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Text(
                "Name",
                style: AppWidget.semiBoldTextFeildStyle(),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                    color: Color(0xfff4f5f9),
                    borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Name"),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Email",
                style: AppWidget.semiBoldTextFeildStyle(),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                    color: Color(0xfff4f5f9),
                    borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Email"),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Password",
                style: AppWidget.semiBoldTextFeildStyle(),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                    color: Color(0xfff4f5f9),
                    borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "password"),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 50.0,
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text("SIGN UP",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold))),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: AppWidget.LightTextFeildStyle(),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
