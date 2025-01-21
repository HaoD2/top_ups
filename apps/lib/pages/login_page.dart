import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});
  static const routeName = '/login';

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  // TextEditingController untuk email dan password
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // Bersihkan controller untuk mencegah kebocoran memori
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Consumer(
            builder: (context, ref, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () {
                      // TODO: Implement login logic here
                      // ref.read<AuthService>().login(emailController.text, passwordController.text);
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
