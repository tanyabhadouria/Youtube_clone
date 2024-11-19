// ignore_for_file: unnecessary_null_comparison, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:you_tube/cores/screens/loader.dart';
import 'package:you_tube/features/auth/pages/login_page.dart';
import 'package:you_tube/features/auth/pages/username_page.dart';

import 'package:you_tube/firebase_options.dart';
import 'package:you_tube/home_page.dart';

//import 'package:you_tube/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // we check wthether we are signed in or not
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoginPage();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader();
          }
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              final user = FirebaseAuth.instance.currentUser;
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return UsernamePage(
                  displayName: user!.displayName!,
                  profilePic: user.photoURL!,
                  email: user.email!,
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Loader();
              }
              return HomePage();
            },
          );
        },
      ),
    );
  }
}
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:you_tube/cores/screens/loader.dart';
// import 'package:you_tube/features/auth/pages/login_page.dart';
// import 'package:you_tube/features/auth/pages/username_page.dart';
// import 'package:you_tube/firebase_options.dart';
// import 'package:you_tube/home_page.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(ProviderScope(child: MyApp()));
// }

// class MyApp extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.dark(), // Set default theme to dark
//       home: StreamBuilder(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return LoginPage();
//           } else if (snapshot.connectionState == ConnectionState.waiting) {
//             return Loader();
//           }
//           return StreamBuilder(
//             stream: FirebaseFirestore.instance
//                 .collection("users")
//                 .doc(FirebaseAuth.instance.currentUser!.uid)
//                 .snapshots(),
//             builder: (context, snapshot) {
//               final user = FirebaseAuth.instance.currentUser;
//               if (!snapshot.hasData || !snapshot.data!.exists) {
//                 return UsernamePage(
//                   displayName: user!.displayName!,
//                   profilePic: user.photoURL!,
//                   email: user.email!,
//                 );
//               } else if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Loader();
//               }
//               return HomePage();
//             },
//           );
//         },
//       ),
//     );
//   }
// }
