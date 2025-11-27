import 'package:flutter/material.dart';
import '../../data/models/index.dart';
import '../../data/repositories/user_repository.dart';
import 'package:uuid/uuid.dart';

/// ViewModel pour l'authentification
class AuthViewModel extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  /// Inscription
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Vérifier si l'email existe déjà
      final existingUser =
          await _userRepository.getUserByEmail(email);
      if (existingUser != null) {
        _errorMessage = 'Email already exists';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Créer le nouvel utilisateur
      final success = await _userRepository.signUp(
        id: const Uuid().v4(),
        name: name,
        email: email,
        password: password,
      );

      if (success) {
        _currentUser = await _userRepository.getUserByEmail(email);
        _errorMessage = null;
      } else {
        _errorMessage = 'Signup failed';
      }

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Connexion
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _userRepository.login(
        email: email,
        password: password,
      );

      if (_currentUser != null) {
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid email or password';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Déconnexion
  void logout() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }
}
