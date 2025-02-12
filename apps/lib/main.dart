import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_ups/pages/home.dart';
import 'package:top_ups/pages/login_page.dart';
import 'package:top_ups/pages/state/loginstate.dart';
import 'package:top_ups/provider/baseProvider.dart';
import 'package:top_ups/repository/authRepo.dart';
import 'package:top_ups/ui/homeBase/game/game.dart';
import 'package:top_ups/ui/homeBase/game/gameDetail.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Pastikan binding sudah diinisialisasi
  await Firebase.initializeApp(); // Inisialisasi Firebase
  await SharedPreferences.getInstance();
  runApp(const ProviderScope(child: const MyApp()));
}

final navigatorProvider = Provider<NavigatorState?>((ref) {
  return ref.watch(navigatorKeyProvider).currentState;
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  Future<bool> _isLoggedIn() async {
    final authRepository = AuthRepository();
    final token = await authRepository.getToken();
    return token != null; // Jika ada token, berarti sudah login
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigatorKey = ref.watch(navigatorKeyProvider);
    final authState = ref.watch(authStateProvider);
    return FutureBuilder<bool>(
      future: _isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        final bool isLoggedIn = snapshot.data ?? false;

        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          navigatorKey: navigatorKey,
          initialRoute: isLoggedIn ? homeMenu.routeName : loginPage.routeName,
          onGenerateRoute: (settings) {
            final uri = Uri.parse(settings.name ?? '');
            if (uri.pathSegments.isNotEmpty) {
              if (uri.pathSegments[0] == 'homeMenu') {
                if (uri.pathSegments.length == 2 &&
                    uri.pathSegments[1] == 'homeGame') {
                  return MaterialPageRoute(builder: (_) => HomeGame());
                } else if (uri.pathSegments.length == 3) {
                  final gameName = uri.pathSegments[2];
                  return MaterialPageRoute(
                      builder: (_) => GameDetailPage(gameName: gameName));
                }
              }
            }
            return null; // Jika route tidak ditemukan
          },
          routes: {
            loginPage.routeName: (context) => const loginPage(),
            homeMenu.routeName: (context) => const homeMenu(),
            HomeGame.routeName: (context) => HomeGame(),
          },
        );
      },
    );
  }
}
