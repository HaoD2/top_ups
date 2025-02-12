import 'package:firebase_auth/firebase_auth.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:top_ups/model/VoucherModel.dart';
import 'package:top_ups/model/gameCurrency.dart';
import 'package:top_ups/model/gameModel.dart';
import 'package:top_ups/model/gamePass.dart';
import 'package:top_ups/model/product.dart';
import 'package:top_ups/pages/state/loginstate.dart';
import 'package:top_ups/repository/authRepo.dart';
import 'package:top_ups/repository/productRepo.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// StreamProvider untuk memantau perubahan autentikasi
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Provider untuk LoginNotifier
final loginNotifierProvider = StateNotifierProvider<LoginNotifier, LoginState>(
  (ref) {
    final authRepository = ref.read(authRepositoryProvider);
    return LoginNotifier(authRepository, ref);
  },
);

final indexBottomNavbarProvider = StateProvider<int>((ref) {
  return 0;
});

final selectedGameProvider = StateProvider<String?>((ref) => null);

final firebaseRepositoryProvider = Provider<FirebaseRepository>((ref) {
  return FirebaseRepository();
});

final productsProvider =
    FutureProvider.family<List<BaseProduct>, Map<String, String?>>(
        (ref, params) async {
  final repo = ref.read(firebaseRepositoryProvider);
  final category = params['category'] ?? "Games";
  final gameType = params['gameType'] ?? "default";
  print("🔍 Fetching products with category: $category, gameType: $gameType");

  List<BaseProduct> products = await repo.fetchProducts(category, gameType);
  print(
      "📋 Final Products List: ${products.map((p) => p.toString()).toList()}");

  return products;
});

final gamesProvider = FutureProvider<List<GameModel>>((ref) async {
  return FirebaseRepository().fetchGames();
});

final voucherProvider = FutureProvider<List<VoucherModel>>((ref) async {
  final repo = ref.read(firebaseRepositoryProvider);
  final vouchers = await repo.fetchVoucher(); // Tanpa parameter
  print("✅ Fetched vouchers: $vouchers");
  return vouchers;
});
