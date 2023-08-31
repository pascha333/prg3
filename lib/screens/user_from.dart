import 'package:flutter/material.dart';
import 'package:prg3/models/user.dart';
import 'package:prg3/models/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:email_validator/email_validator.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => __UserFormState();
}

class __UserFormState extends State<UserForm> {
  final _formkey = GlobalKey<FormState>();
  //Users user = Users();
  late Users user;

  Future<void> addNewUser(user) async {
    var url = Uri.http(configure.server, "users");
    var resp = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()));
    var rs = usersFromJson("[${resp.body}]");
    if (rs.length == 1) {
      Navigator.pop(context, "refresh");
    }
    return;
  }

  Future<void> updateData(user) async {
    var url = Uri.http(configure.server, "users/${user.id}");
    var resp = await http.put(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()));
    var rs = usersFromJson("[${resp.body}]");
    if (rs.length == 1) {
      Navigator.pop(context, "refresh");
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    try {
      user = ModalRoute.of(context)!.settings.arguments as Users;
      print(user.fullname);
    } catch (e) {
      user = Users();
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("User Form"),
        ),
        body: Container(
          margin: EdgeInsets.all(10.0),
          child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  fnameInputField(),
                  emailInputField(),
                  passwordInputField(),
                  genderFormInput(),
                  SizedBox(
                    height: 10.0,
                  ),
                  SubmitButton(),
                ],
              )),
        ));
  }

  Widget fnameInputField() {
    return TextFormField(
      initialValue: user.fullname,
      decoration: InputDecoration(
        labelText: 'Fullname',
        icon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'This field is requried';
        }
        return null;
      },
      onSaved: (newValue) => user.fullname = newValue,
    );
  }

  Widget emailInputField() {
    return TextFormField(
      initialValue: user.email,
      decoration: InputDecoration(
        labelText: 'Email',
        icon: Icon(Icons.email),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'This field is requried';
        }
        if (!EmailValidator.validate(value)) {
          return 'It is not email format';
        }
        return null;
      },
      onSaved: (newValue) => user.email = newValue!,
    );
  }

  Widget passwordInputField() {
    return TextFormField(
      initialValue: user.password,
      obscureText: true,
      decoration:
          InputDecoration(labelText: 'password', icon: Icon(Icons.lock)),
      validator: (value) {
        if (value!.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
      onSaved: (newValue) => user.password = newValue!,
    );
  }

  Widget genderFormInput() {
    // ignore: unused_local_variable
    var initGen = "None";
    try {
      if (!user.gender!.isEmpty) {
        initGen = user.gender!;
      }
    } catch (e) {
      initGen = "None";
    }
    return DropdownButtonFormField(
        decoration: InputDecoration(
          labelText: 'Gender:',
          icon: Icon(Icons.man),
        ),
        value: 'None',
        items: configure.gender.map((String val) {
          return DropdownMenuItem(
            value: val,
            child: Text(val),
          );
        }).toList(),
        onChanged: (value) {
          user.gender = value;
        },
        onSaved: (newValue) => user.gender);
  }

  Widget SubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formkey.currentState!.validate()) {
          _formkey.currentState!.save();
          print(user.toJson().toString());
          addNewUser(user);
          if (user.id == null) {
            addNewUser(user);
          } else {
            updateData(user);
          }
        }
      },
      child: Text('Save'),
    );
  }
}
