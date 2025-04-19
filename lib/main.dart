import 'package:bazarmela/firebase_options.dart';
import 'package:bazarmela/view/Role/Admin/Screens/admin_home_screen.dart';
import 'package:bazarmela/view/Role/User/user_home_Screen.dart';
import 'package:bazarmela/view/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter binding is initialized
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   try {
//     await Firebase.initializeApp();
//     print("✅ Firebase Initialized!");
//   } catch (e) {
//     print("❌ Firebase Initialization failed: $e");
//   }
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const AuthHandleState(),
      ),
    );
  }
}

class AuthHandleState extends StatefulWidget {
  const AuthHandleState({super.key});

  @override
  State<AuthHandleState> createState() => _AuthHandleStateState();
}

class _AuthHandleStateState extends State<AuthHandleState> {
  User? _currentUser;
  String? _userRole;

  @override
  void initState() {
    _initializeAuthState();
    super.initState();
  }

  void _initializeAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (!mounted) return;
      setState(() {
        _currentUser = user;
      });
      if (user != null) {
        final userDoc =
            await FirebaseFirestore.instance
                .collection("users")
                .doc(user.uid)
                .get();
        if (!mounted) return;
        if (userDoc.exists) {
          setState(() {
            _userRole = userDoc['role'];
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return LoginScreen();
    }
    if (_userRole == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return _userRole == "Admin" ? AdminHomeScreen() : UserHomeScreen();
  }
}
