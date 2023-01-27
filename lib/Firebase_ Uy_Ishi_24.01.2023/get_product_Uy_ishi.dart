import 'package:authlogin/Firebase_%20Uy_Ishi_24.01.2023/addProduct_uy_ishi.dart';
import 'package:authlogin/Firebase_%20Uy_Ishi_24.01.2023/dynamic_Link_Page.dart';
import 'package:authlogin/model/uy_ishi_products_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:url_launcher/url_launcher.dart';

import '../Firebase_sinf_ishi/add_product.dart';

class getProduct_Uy_ishi extends StatefulWidget {
  const getProduct_Uy_ishi({Key? key}) : super(key: key);

  @override
  State<getProduct_Uy_ishi> createState() => _getProduct_Uy_ishiState();
}


class _getProduct_Uy_ishiState extends State<getProduct_Uy_ishi> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  List<ProductModelUyishi> list = [];
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
      data = await fireStore.collection("продукты").get();
    } else {
      data = await fireStore.collection("продукты").orderBy("name").startAt(
          [text.toLowerCase()]).endAt(["${text.toLowerCase()}\uf8ff"]).get();
    }
    // print(data?.docs.length);
    listOfDoc.clear();
    list.clear();
    for (var element in data?.docs ?? []) {
      list.add(ProductModelUyishi.fromJson(element));
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
            padding: const EdgeInsets.all(24.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "Search",
              ),
              onChanged: (s) {
                getInfo(text: s);
              },
            ),
          ),
          SizedBox(height: 30,),
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
                              SizedBox(
                                // width: MediaQuery.of(context).size.width-250,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(

                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 150,
                                            width: 150,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage( list[index].image ?? ""),
                                                fit: BoxFit.fill,
                                              )
                                            )
                                          ),
                                        )),
                                    Text(
                                        "${list[index].name.substring(0, 1).toUpperCase()}${list[index].name.substring(1)}"),
                                    Text(list[index].info),
                                    Text(list[index].type),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  print(list.length);
                                  print(listOfDoc.length);
                                  fireStore
                                      .collection("продукты")
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
          Padding(padding: EdgeInsets.only(left: 220),

            child: Row(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const dynamicLinkPage_Uy_ishi()));
                  },
                  child:  Icon(Icons.link, ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => AddProduct_Uy_ishi()));
                  },
                  child:  Icon(Icons.add, ),
                ),
              ],
            ),
          ),

        ],
      ),


    );
  }
}
