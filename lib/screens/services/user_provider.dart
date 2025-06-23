import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserProvider with ChangeNotifier {
  String? _userName;
  String? _userEmail;
  String? _userToken; // Opcional: armazenar o token aqui também

  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userToken => _userToken;

  bool get isAuthenticated => _userToken != null && _userToken!.isNotEmpty;

  // Método para carregar os dados do usuário do token
  Future<void> loadUserFromToken() async {
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    String? token = _sharedPreferences.getString('token');

    if (token != null && token.isNotEmpty) {
      try {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

        // Adapte 'name' e 'email' para as chaves reais do seu JWT
        _userName = decodedToken['name']; // Ex: 'name', 'username'
        _userEmail = decodedToken['email']; // Ex: 'email', 'user_email'
        _userToken = token; // Armazena o token puro

        notifyListeners(); // Notifica os widgets que estão "ouvindo" as mudanças
        print('Usuário carregado: Nome: $_userName, Email: $_userEmail');
      } catch (e) {
        print('Erro ao decodificar o token JWT: $e');
        await _sharedPreferences.remove('token');
        _userToken = null;
        _userName = null;
        _userEmail = null;
        notifyListeners();
      }
    } else {
      _userToken = null;
      _userName = null;
      _userEmail = null;
      notifyListeners();
    }
  }

  // Método para salvar o token e carregar os dados do usuário (chamado no login)
  Future<void> login(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token); 
    await loadUserFromToken();
  }

  // Método para deslogar o usuário
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _userToken = null;
    _userName = null;
    _userEmail = null;
    notifyListeners();
  }
}