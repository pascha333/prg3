import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:prg3/models/config.dart';
import 'package:prg3/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:prg3/screens/home.dart';

//LOGIN
class Login extends StatefulWidget {
  static const routeName = "/login";
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  Users user = Users();

  Future<void> login(Users user) async {
    var params = {"email": user.email, "password": user.password};

    var url = Uri.http(configure.server, "users", params);
    var resp = await http.get(url);
    print(resp.body);
    List<Users> login_result = usersFromJson(resp.body);
    print(login_result.length);
    if (login_result.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("username or passwors invalid")));
    } else {
      configure.login = login_result[0];
      Navigator.pushNamed(context, Home.routeName);
    }
    return;
  }

  // Widget textHeader() {
  //   return Align(
  //     alignment: Alignment.center,
  //     child: Container(
  //       child: Text(
  //         'Login',
  //         style: TextStyle(
  //           fontSize: 10,
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Widget emailInputField() {
    return TextFormField(
      // initialValue: "a@test.com",
      decoration:
          InputDecoration(labelText: "Email : ", icon: Icon(Icons.email)),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        if (!EmailValidator.validate(value)) {
          return "It is not email format";
        }
        return null;
      },
      onSaved: (newValue) => user.email = newValue!,
    );
  }

  Widget passwordInputField() {
    return TextFormField(
      // initialValue: "1234",
      obscureText: true,
      decoration:
          InputDecoration(labelText: "Password : ", icon: Icon(Icons.lock)),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => user.password = newValue!,
    );
  }

  Widget submitButton() {
    return ElevatedButton(
        onPressed: () {
          if (_formkey.currentState!.validate()) {
            _formkey.currentState!.save();
            print(user.toJson().toString());
            login(user);
          }
        },
        child: Text("Login"));
  }

  Widget BackButton() {
    return ElevatedButton(onPressed: () {}, child: Text("Back"));
  }

  Widget registerLink() {
    return InkWell(
      child: const Text("Sign Up"),
      onTap: () {},
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //textHeader(),
                emailInputField(),
                passwordInputField(),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    submitButton(),
                    SizedBox(
                      width: 10.0,
                    ),
                    BackButton(),
                    SizedBox(
                      width: 10.0,
                    ),
                    registerLink()
                  ],
                )
              ],
            )),
      ),
    );
  }
}
