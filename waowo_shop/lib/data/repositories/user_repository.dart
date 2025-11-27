import 'package:crypto/crypto.dart';
import '../models/index.dart';
import '../database/database_helper.dart';

/// Repository pour les utilisateurs
class UserRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  /// Enregistrer un nouvel utilisateur
  Future<bool> signUp({
    required String id,
    required String name,
    required String email,
    required String password,
  }) async {
    final passwordHash = sha256.convert(password.codeUnits).toString();
    final user = User(
      id: id,
      name: name,
      email: email,
      passwordHash: passwordHash,
      createdAt: DateTime.now(),
    );
    return _databaseHelper.createUser(user);
  }

  /// Connexion utilisateur
  Future<User?> login({required String email, required String password}) async {
    final user = await _databaseHelper.getUserByEmail(email);
    if (user == null) return null;

    final passwordHash = sha256.convert(password.codeUnits).toString();
    if (user.passwordHash == passwordHash) {
      return user;
    }
    return null;
  }

  /// Obtenir un utilisateur par email
  Future<User?> getUserByEmail(String email) async {
    return _databaseHelper.getUserByEmail(email);
  }

  /// Mettre à jour le profil utilisateur
  Future<bool> updateProfile({
    required String userId,
    String? name,
    String? phone,
    String? address,
  }) async {
    final user = await _databaseHelper.getUserByEmail('dummy@example.com');
    if (user == null) return false;

    final updatedUser = user.copyWith(
      name: name ?? user.name,
      phone: phone ?? user.phone,
      address: address ?? user.address,
    );
    return _databaseHelper.updateUser(updatedUser);
  }
}
