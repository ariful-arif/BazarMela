import 'package:bazarmela/Services/auth_service.dart';
import 'package:bazarmela/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String selectRole = "User";
  bool isLoading = false;

  final AuthService _authService = AuthService();

  void _signup() async {
    setState(() {
      isLoading = true;
    });
    String? result = await _authService.signup(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      role: selectRole,
    );
    setState(() {
      isLoading = false;
    });
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup Successfully! Now turn on Login")),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Signup Failed. $result")));
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
                // input name
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                // input email
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                // input password
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                // input password
                DropdownButtonFormField(
                  value: selectRole,
                  decoration: const InputDecoration(
                    labelText: "Role",
                    border: OutlineInputBorder(),
                  ),
                  items:
                      ["Admin", "User"].map((role) {
                        return DropdownMenuItem(value: role, child: Text(role));
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectRole = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _signup,
                        child: Text("Sign up"),
                      ),
                    ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?  ",
                      style: TextStyle(fontSize: 18),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Login",
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
