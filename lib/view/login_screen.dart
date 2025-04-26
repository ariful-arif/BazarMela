import 'package:bazarmela/Services/auth_service.dart';
import 'package:bazarmela/view/Role/Admin/Screens/admin_home_screen.dart';
import 'package:bazarmela/view/Role/User/user_home_Screen.dart';
import 'package:bazarmela/view/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  final AuthService _authService = AuthService();

  void login() async {
    setState(() {
      isLoading = true;
    });
    String? result = await _authService.login(
      email: emailController.text,
      password: passwordController.text,
    );
    setState(() {
      isLoading = false;
    });
    if (result == "Admin") {
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(SnackBar(content: Text("Login Successfully")));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminHomeScreen()),
      );
    } else if (result == "User") {
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(SnackBar(content: Text("Login Successfully")));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AppMainScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login Failed. $result")));
      print(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Lottie.asset("assets/images/login.json"),
                const SizedBox(height: 15),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: login,
                        child: Text("Login"),
                      ),
                    ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?  ",
                      style: TextStyle(fontSize: 18),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "SignUp here",
                        style: TextStyle(fontSize: 18, color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
