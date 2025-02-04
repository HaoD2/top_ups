import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:top_ups/pages/home.dart';
import 'package:top_ups/pages/login_page.dart';
import 'package:top_ups/pages/state/loginstate.dart';
import 'package:top_ups/provider/baseProvider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Pastikan binding sudah diinisialisasi
  await Firebase.initializeApp(); // Inisialisasi Firebase
  runApp(const ProviderScope(child: const MyApp()));
}
final navigatorProvider = Provider<NavigatorState?>((ref) {
  return ref.watch(navigatorKeyProvider).currentState;
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigatorKey = ref.watch(navigatorKeyProvider);
    final authState = ref.watch(authStateProvider);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      routes: {
        loginPage.routeName: (context) => const loginPage(),
        homeMenu.routeName: (context) => const homeMenu(),
      },
      home: LoginState is LoginStateSuccess
          ? const homeMenu()
          : const loginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      routes: {
        loginPage.routeName: (context) => const loginPage(),
        homeMenu.routeName: (context) => const homeMenu(),
      },
      supportedLocales: const [
        Locale('id', 'ID'),
      ],
      home: const loginPage(),
    );
  }
}
