import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModelUyishi {
  final String name;
  final String image;
  final String info;
  final String type;

  ProductModelUyishi(
      {required this.image,
      required this.info,
      required this.name,
      required this.type});

  factory ProductModelUyishi.fromJson(QueryDocumentSnapshot data) {
    return ProductModelUyishi(
        name: data["name"],
        image: data["image"],
        info: data["info"],
        type: data["type"]);
  }

  toJson() {
    return {"name": name, "image": image, "info": info, "type": type};
  }
}
