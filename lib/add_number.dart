import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class AddNumber extends StatefulWidget {
  const AddNumber({Key? key}) : super(key: key);

  @override
  State<AddNumber> createState() => _AddNumberState();
}

class _AddNumberState extends State<AddNumber> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: TextFormField(
            controller: controller,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: controller.text,
            verificationCompleted: (PhoneAuthCredential credential) {},
            verificationFailed: (FirebaseAuthException e) {},
            codeSent: (String verificationId, int? resendToken) {},
            codeAutoRetrievalTimeout: (String verificationId) {},
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}





