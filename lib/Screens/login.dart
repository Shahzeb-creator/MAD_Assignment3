import 'package:assignment/Screens/dashboard.dart';
import 'package:assignment/validator.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool obscure = true;
  bool remember = false;

  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                validator: (v) => Validator.validateEmail(v!),
                onChanged: (v) => email = v,
              ),
              TextFormField(
                obscureText: obscure,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() => obscure = !obscure);
                    },
                  ),
                ),
                validator: (v) => Validator.validatePassword(v!),
                onChanged: (v) => password = v,
              ),
              Row(
                children: [
                  Checkbox(
                    value: remember,
                    onChanged: (v) {
                      setState(() => remember = v!);
                    },
                  ),
                  Text("Remember Me")
                ],
              ),
              ElevatedButton(
                child: Text("Login"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>DashboardScreen()));
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