import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:top_ups/pages/state/loginstate.dart';
import 'package:top_ups/provider/baseProvider.dart';

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
              // Pantau status login menggunakan loginNotifierProvider
              final loginState = ref.watch(loginNotifierProvider);
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
                  // Tampilkan indikator loading jika sedang login
                  if (loginState is LoginStateLoading)
                    const CircularProgressIndicator(),
                  if (loginState is! LoginStateLoading) ...[
                    if (loginState is LoginStateError)
                      Text(
                        loginState.error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ElevatedButton(
                      child: const Text('Login'),
                      onPressed: () {
                        // Panggil fungsi login pada LoginNotifier
                        ref.read(loginNotifierProvider.notifier).login({
                          "email": emailController.text.trim(),
                          "password": passwordController.text.trim(),
                        });
                      },
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
