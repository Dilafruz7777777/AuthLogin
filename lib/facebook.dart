import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
class Facebook extends StatefulWidget {
  const Facebook({Key? key}) : super(key: key);

  @override
  State<Facebook> createState() => _FacebookState();
}

class _FacebookState extends State<Facebook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final fb = FacebookLogin();

// Log in
            final res = await fb.logIn(permissions: [
            FacebookPermission.publicProfile,
            FacebookPermission.email,
            ]);

// Check result status
            switch (res.status) {
            case FacebookLoginStatus.success:
            // Logged in

            // Send access token to server for validation and auth
            final FacebookAccessToken? accessToken = res.accessToken;
            print('Access token: ${accessToken?.token}');

            // Get profile data
            final profile = await fb.getUserProfile();
            print('Hello, ${profile?.name}! You ID: ${profile?.userId}');

            // Get user profile image url
            final imageUrl = await fb.getProfileImageUrl(width: 100);
            print('Your profile image: $imageUrl');

            // Get email (since we request email permission)
            final email = await fb.getUserEmail();
            // But user can decline permission
            if (email != null)
            print('And your email is $email');

            break;
            case FacebookLoginStatus.cancel:
            // User cancel log in
            break;
            case FacebookLoginStatus.error:
            // Log in failed
            print('Error while log in: ${res.error}');
            break;
            }

          },
          child: Text("Facebook"),
        ),
      ),
    );
  }
}
