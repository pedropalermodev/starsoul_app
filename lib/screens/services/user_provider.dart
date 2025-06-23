import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http; // Importar http para fazer a requisição
import 'dart:convert'; // Para json.decode

class UserProvider with ChangeNotifier {
  String? _userName;
  String? _userEmail;
  String? _userToken;

  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userToken => _userToken;

  bool get isAuthenticated => _userToken != null && _userToken!.isNotEmpty;

  // Método para carregar os dados do usuário
  Future<void> loadUserFromToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Usar 'prefs' para consistência
    String? token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      try {
        // Opcional: Verificar se o token está expirado antes de fazer a requisição
        if (JwtDecoder.isExpired(token)) {
          print('Token expirado. Deslogando...');
          await _clearUserDataAndLogout(prefs);
          return;
        }

        // Armazena o token puro para uso futuro (ex: em outras requisições)
        _userToken = token;

        // Fazer a requisição para obter os dados do usuário completos
        var url = Uri.parse('https://starsoul-backend.onrender.com/api/usuarios/me'); // <-- SUBSTITUA PELA SUA ROTA REAL DE PERFIL
        var response = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token', // Envia o token no cabeçalho Authorization
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> userDataFromApi = json.decode(response.body);

          // Adapte 'nome' e 'email' para as chaves reais do seu JSON de resposta
          _userName = userDataFromApi['nome'];
          _userEmail = userDataFromApi['email'];

          print('Usuário carregado da API: Nome: $_userName, Email: $_userEmail');
          notifyListeners(); // Notifica os widgets
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          // Token inválido/expirado ou não autorizado na API de perfil
          print('Erro de autenticação ao buscar perfil: ${response.statusCode}');
          await _clearUserDataAndLogout(prefs);
        } else {
          print('Erro ao buscar dados do perfil (Status: ${response.statusCode}): ${response.body}');
          await _clearUserDataAndLogout(prefs); // Pode ser um erro, então desloga
        }

      } catch (e) {
        print('Erro na requisição ou decodificação do token/API: $e');
        await _clearUserDataAndLogout(prefs);
      }
    } else {
      // Nenhum token encontrado nas SharedPreferences
      await _clearUserDataAndLogout(prefs);
    }
  }

  // Método auxiliar para limpar dados e deslogar
  Future<void> _clearUserDataAndLogout(SharedPreferences prefs) async {
    await prefs.remove('token');
    _userToken = null;
    _userName = null;
    _userEmail = null;
    notifyListeners();
  }

  // Método para salvar o token e carregar os dados do usuário (chamado no login)
  Future<void> login(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await loadUserFromToken(); // Agora, loadUserFromToken fará a requisição HTTP
  }

  // Método para deslogar o usuário
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await _clearUserDataAndLogout(prefs);
  }
}