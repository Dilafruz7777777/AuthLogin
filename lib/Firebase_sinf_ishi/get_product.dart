import 'package:authlogin/Firebase_sinf_ishi/add_product.dart';
import 'package:authlogin/Firebase_sinf_ishi/dynamic_link.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../model/product_model.dart';

class getProduct extends StatefulWidget {
  const getProduct({Key? key}) : super(key: key);

  @override
  State<getProduct> createState() => _getProductState();
}

class _getProductState extends State<getProduct> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  List<ProductModel> list = [];
  List listOfDoc = [];
  QuerySnapshot? data;
  bool isLoading = true;

  Future<void> getInfo({String? text}) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      print("onBackgroundMessage");
      // app chiqib ketganda
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage");
    });

    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("fcm: $fcmToken");

    isLoading = true;
    setState(() {});
    if (text == null) {
      data = await fireStore.collection("Product").get();
    } else {
      data = await fireStore.collection("Product").orderBy("name").startAt(
          [text.toLowerCase()]).endAt(["${text.toLowerCase()}\uf8ff"]).get();
    }
    // print(data?.docs.length);
    listOfDoc.clear();
    list.clear();
    for (var element in data?.docs ?? []) {
      list.add(ProductModel.fromJson(element));
      listOfDoc.add(element.id);
    }
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "Search",
              ),
              onChanged: (s) {
                getInfo(text: s);
              },
            ),
          ),
          isLoading
              ? CircularProgressIndicator()
              : Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.purpleAccent.withOpacity(0.2),
                          ),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                      height: 120,
                                      width: 120,
                                      child: Image.network(
                                          list[index].image ?? "")),
                                  Text(
                                      "${list[index].name.substring(0, 1).toUpperCase()}${list[index].name.substring(1)}"),
                                  Text(list[index].desc),
                                  Text(list[index].price.toString()),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  print(list.length);
                                  print(listOfDoc.length);
                                  fireStore
                                      .collection("Product")
                                      .doc(listOfDoc[index] ?? "")
                                      .delete()
                                      .then(
                                        (doc) => print("Document deleted"),
                                        onError: (e) =>
                                            print("Error updating document $e"),
                                      );
                                  list.removeAt(index);
                                  listOfDoc.removeAt(index);
                                  print(list.length);
                                  print(listOfDoc.length);
                                  // firebase dan o'chiirldi, delete o'xshadi
                                  // listdanam remove bo'ldi
                                  // lekin data  da remove bo'madi
                                  //
                                  setState(() {});
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const dynamicLinkPage()));
            },
            child: const Icon(Icons.link),
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AddProduct()));
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),

      // FutureBuilder(
      //   future: fireStore.collection("Product").where("price",isGreaterThanOrEqualTo: 115).get(),
      //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //     if(snapshot.hasData){
      //       list.clear();
      //       snapshot.data?.docs.forEach((element) {
      //         list.add(ProductModel.fromJson(element));
      //       });
      //       return ListView.builder(
      //         itemCount: list.length,
      //           itemBuilder: (context, index) {
      //         return Container(
      //           margin: EdgeInsets.only(bottom: 20),
      //           padding: EdgeInsets.only(left: 30, right: 30),
      //           decoration: BoxDecoration(
      //             color: Colors.purpleAccent.withOpacity(0.2),
      //           ),
      //           child: Column(
      //             children: [
      //               Text(list[index].name),
      //               Text(list[index].desc),
      //               Text(list[index].price.toString()),
      //
      //             ],
      //           ),
      //         );
      //       });
      //
      //
      //     }else if (snapshot.hasError) {
      //       return  Center(child: Text(snapshot.error.toString()),);
      //     }else{
      //       return const Center(child: CircularProgressIndicator(),);
      //     }
      //   },
      // ),
    );
  }
}
