import 'package:authlogin/Firebase_%20Uy_Ishi_24.01.2023/get_product_Uy_ishi.dart';
import 'package:authlogin/Firebase_sinf_ishi/get_product.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'add_number.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: getProduct_Uy_ishi(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String? avatar;
  String? name;
  String? email;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  GoogleSignIn _googleSignIn = GoogleSignIn();
                  var data = await _googleSignIn.signIn();
                  print(data?.id);
                  print(data?.email);
                  print(data?.photoUrl);
                  print(data?.displayName);
                  avatar = data?.photoUrl;
                  name = data?.displayName;
                  email = data?.email;
                  setState(() {});
                  _googleSignIn.signOut();
                } catch (e) {
                  print(e);
                }
              },
              child: const Text("Google sign"),
            ),
            SizedBox(height: 10,),
            avatar == null ? SizedBox.shrink() : Image.network(avatar ?? ""),
            SizedBox(height: 10,),
            name == null ? SizedBox.shrink() : Text(name ?? ""),
            SizedBox(height: 10,),

            email == null ? SizedBox.shrink() : Text(email ?? ""),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}