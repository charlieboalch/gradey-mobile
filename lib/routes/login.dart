import 'package:flutter/material.dart';
import 'package:gradey/struct/arguments.dart';
import 'package:path_provider/path_provider.dart';
import 'package:studentvue/studentvue.dart';
import 'package:tuple/tuple.dart';
import 'dart:io';

class LoginRoute extends StatelessWidget {
  const LoginRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            StatefulLoginForm()
          ],
        ),
      ),
    );
  }
}

class StatefulLoginForm extends StatefulWidget {
  const StatefulLoginForm({super.key});
  @override
  State<StatefulLoginForm> createState() => _StatefulLoginFormState();
}

class _StatefulLoginFormState extends State<StatefulLoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _username = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _readCreds().then((value) => {
      _username.text = value.item1
    });

    _readCreds().then((value) => {
      _password.text = value.item2
    });

    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Text('Log into StudentVue',
              style: TextStyle(
                  fontSize: 30
              ),),
            TextFormField(
              controller: _username,
              decoration: const InputDecoration(
                hintText: 'Username / Student ID',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Enter your username';
                }
                return null;
              }
              ,
            ),
            TextFormField(
              controller: _password,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Enter your password';
                }
                return null;
              },
              obscureText: true,
              autocorrect: false,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    var client = await StudentVue.login('https://ga-gcps-psv.edupoint.com', _username.text, _password.text);
                    await _writeCreds(_username.text, _password.text);
                    if (context.mounted) Navigator.of(context).pushReplacementNamed('/home', arguments: HomeArguments(client));
                  } on Exception catch (_, e){
                    _username.clear();
                    _password.clear();
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String> _localPath() async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> _localFile (pathname) async {
  final path = await _localPath();
  var file = File('$path/$pathname');
  return file;
}

_writeCreds(username, password) async {
  File file = await _localFile('data.grade');
  String plaintext = username + "[%&BREAK%&]" + password;
  file.writeAsString(plaintext);
}

//username, password
Future<Tuple2<String, String>> _readCreds() async {
  File file = await _localFile('data.grade');

  String data = await file.readAsString();
  return Tuple2(data.split("[%&BREAK%&]").first, data.split("[%&BREAK%&]").last);
}


