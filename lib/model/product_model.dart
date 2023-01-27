import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String name;
  final String desc;
  final num price;
  final String? image;

  ProductModel(
      {required this.desc,
      required this.image,
      required this.price,
      required this.name});

  factory ProductModel.fromJson(QueryDocumentSnapshot data) {
    return ProductModel(
        name: data["name"],
        image: data["image"],
        desc: data["desc"],
        price: data["price"]);
  }

  toJson() {
    return {
      "name": name,
      "desc": desc,
      "price": price,
      "image": image,
    };
  }
}
