
import 'dart:io';

import 'package:authlogin/Firebase_%20Uy_Ishi_24.01.2023/get_product_Uy_ishi.dart';
import 'package:authlogin/model/uy_ishi_products_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class AddProduct_Uy_ishi extends StatefulWidget {
  const AddProduct_Uy_ishi({Key? key}) : super(key: key);

  @override
  State<AddProduct_Uy_ishi> createState() => _AddProduct_Uy_ishiState();
}

class _AddProduct_Uy_ishiState extends State<AddProduct_Uy_ishi> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController infoController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController typeController = TextEditingController();


  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final storageRef = FirebaseStorage.instance.ref();
  final ImagePicker _picker = ImagePicker();
  String? ImagePath;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ImagePath == null
                  ? SizedBox.shrink()
                  : Image.file(File(ImagePath!)),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                ),
              ),
              TextFormField(
                controller: typeController,
                decoration: InputDecoration(
                  labelText: "type",
                ),
              ),
              TextFormField(
                controller: infoController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(labelText: "Info"),
              ),
              ElevatedButton(
                  onPressed: () async {
                    final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                    ImagePath = image?.path;
                    setState(() {});
                  },
                  child: Text("Add Image from gallery")),
              ElevatedButton(
                  onPressed: () async {
                    final XFile? photo =
                    await _picker.pickImage(source: ImageSource.camera);
                    ImagePath = photo?.path;
                    setState(() {});
                  },
                  child: Text("Add Image")),
              ElevatedButton(
                onPressed: () async {
                  isLoading = true;
                  setState(() {});
                  final storageRef = FirebaseStorage.instance.ref().child("продуктыImage/${DateTime.now().toString()}");
                  await storageRef.putFile(File(ImagePath ?? ""));

                  String url = await storageRef.getDownloadURL();
                  fireStore
                      .collection("продукты")
                      .add(ProductModelUyishi(
                      image: url,
                      type: typeController.text,
                      name: nameController.text.toLowerCase(),
                      info: infoController.text.toLowerCase())
                      .toJson())
                      .then((value) {
                    isLoading = false;
                    setState(() {});
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const getProduct_Uy_ishi()),
                            (route) => false);
                  });
                },
                child: isLoading ? CircularProgressIndicator(color: Colors.white,)
                    : Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
