import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
class dynamicLinkPage extends StatefulWidget {
  const dynamicLinkPage({Key? key}) : super(key: key);

  @override
  State<dynamicLinkPage> createState() => _dynamicLinkPageState();
}

class _dynamicLinkPageState extends State<dynamicLinkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dynamic link"),
      ),
      body: Center(
       child: Text("Generate link"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final dynamicLinkParams = DynamicLinkParameters(
            link: Uri.parse("https://www.figma.com/file/9Uyc7FtDZQdTCKy2aENrft/Foode---Food-Delivery-Mobile-App-UI-Kit?node-id=2349%3A53722"),
            uriPrefix: "https://authlogin.page.link",
            androidParameters:  AndroidParameters(packageName: "com.example.authlogin", fallbackUrl: Uri.parse("https://www.figma.com/file/9Uyc7FtDZQdTCKy2aENrft/Foode---Food-Delivery-Mobile-App-UI-Kit?node-id=2349%3A53722")),
            iosParameters:  IOSParameters(bundleId: "com.example.authlogin", fallbackUrl: Uri.parse("https://www.figma.com/file/9Uyc7FtDZQdTCKy2aENrft/Foode---Food-Delivery-Mobile-App-UI-Kit?node-id=2349%3A53722")),
         socialMetaTagParameters: SocialMetaTagParameters(
           title: "Title",
           description: "Desc",
           imageUrl: Uri.parse("https://media.istockphoto.com/id/1368264124/photo/extreme-close-up-of-thrashing-emerald-ocean-waves.jpg?b=1&s=170667a&w=0&k=20&c=qha_PaU54cu9QCu1UTlORP4-sW0MqLGERkdFKmC06lI="),

         ),
          );
          final dynamicLink =
              await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
          print(dynamicLink.shortUrl);
        },
        child: Text("+"),
      ),
    );
  }
}
