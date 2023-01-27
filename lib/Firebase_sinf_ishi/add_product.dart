import 'dart:io';

import 'package:authlogin/Firebase_sinf_ishi/get_product.dart';
import 'package:authlogin/model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
   final TextEditingController nameController = TextEditingController();
 final TextEditingController priceController = TextEditingController();
 final TextEditingController descController = TextEditingController();

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
                controller: descController,
                decoration: InputDecoration(
                  labelText: "Desc",
                ),
              ),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Price"),
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
                  final storageRef = FirebaseStorage.instance.ref().child("productImage/${DateTime.now().toString()}");
                  await storageRef.putFile(File(ImagePath ?? ""));

                  String url = await storageRef.getDownloadURL();
                  fireStore
                      .collection("Product")
                      .add(ProductModel(
                    image: url,
                              desc: descController.text,
                              name: nameController.text.toLowerCase(),
                              price: double.tryParse(priceController.text) ?? 0)
                          .toJson())
                      .then((value) {
                        isLoading = false;
                        setState(() {});
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const getProduct()),
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
