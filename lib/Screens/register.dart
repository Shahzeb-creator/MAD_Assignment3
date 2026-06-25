import 'package:assignment/Screens/login.dart';
import 'package:assignment/validator.dart';
import 'package:flutter/material.dart';

enum Gender { male, female }

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String confirmPassword = "";
  Gender? gender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (v) => email = v,
                validator: (v) => Validator.validateEmail(v!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                onChanged: (v) => password = v,
                validator: (v) => Validator.validatePassword(v!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Confirm Password"),
                obscureText: true,
                onChanged: (v) => confirmPassword = v,
                validator: (v) {
                  if (v != password) return "Passwords not match";
                  return null;
                },
              ),
              DropdownButtonFormField<Gender>(
                hint: Text("Select Gender"),
                items: Gender.values.map((g) {
                  return DropdownMenuItem(
                    value: g,
                    child: Text(g.name),
                  );
                }).toList(),
                onChanged: (val) => gender = val,
                validator: (v) => v == null ? "Required" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text("Register"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}