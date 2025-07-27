import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart'
    as http; // Importar http para fazer a requisição
import 'dart:convert'; // Para json.decode

class UserProvider with ChangeNotifier {
  int? _userId;
  String? _userName;
  String? _userEmail;
  String? _userToken;
  String? _userNickname;
  DateTime? _userBirthDate;
  String? _userGender;

  int? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userToken => _userToken;
  String? get userNickname => _userNickname;
  DateTime? get userBirthDate => _userBirthDate;
  String? get userGender => _userGender;

  bool get isAuthenticated => _userToken != null && _userToken!.isNotEmpty;

  // Método para carregar os dados do usuário
  Future<void> loadUserFromToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
        var url = Uri.parse(
          'https://starsoul-backend.onrender.com/api/usuarios/me',
        ); // <-- SUBSTITUA PELA SUA ROTA REAL DE PERFIL
        var response = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'Bearer $token', // Envia o token no cabeçalho Authorization
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> userDataFromApi = json.decode(
            response.body,
          );


          _userId = userDataFromApi['id'];
          _userName = userDataFromApi['nome'];
          _userEmail = userDataFromApi['email'];
          if (userDataFromApi['apelido'] != null) {
            _userNickname = userDataFromApi['apelido'];
          } else {
            _userNickname = null;
          }

          if (userDataFromApi['dataNascimento'] != null) {
            _userBirthDate = DateTime.tryParse(
              userDataFromApi['dataNascimento'],
            );
          } else {
            _userBirthDate = null;
          }

          if (userDataFromApi['genero'] != null) {
            _userGender = userDataFromApi['genero'];
          } else {
            _userGender = null;
          }

          print(
            'Usuário carregado da API: Nome: $_userName, Email: $_userEmail',
          );
          notifyListeners();
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          print(
            'Erro de autenticação ao buscar perfil: ${response.statusCode}',
          );
          await _clearUserDataAndLogout(prefs);
        } else {
          print(
            'Erro ao buscar dados do perfil (Status: ${response.statusCode}): ${response.body}',
          );
          await _clearUserDataAndLogout(
            prefs,
          ); // Pode ser um erro, então desloga
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

  Future<bool> updateUser({
    String? newName,
    String? newEmail,
    String? newNickname,
    DateTime? newBirthDate,
    String? newGender,
  }) async {
    if (!isAuthenticated) {
      print('Usuário não autenticado. Impossível atualizar.');
      return false;
    }

    var url = Uri.parse('https://starsoul-backend.onrender.com/api/usuarios/me');
    var token = _userToken;

    Map<String, dynamic> requestBody = {};

    if (newName != null && newName.isNotEmpty) {
      requestBody['nome'] = newName;
    }
    if (newEmail != null && newEmail.isNotEmpty) {
      requestBody['email'] = newEmail;
    }
    if (newNickname != null && newNickname.isNotEmpty) {
      requestBody['apelido'] = newNickname;
    }
    if (newBirthDate != null) {
      requestBody['dataNascimento'] = newBirthDate.toIso8601String().split('T')[0]; // YYYY-MM-DD
    }
    if (newGender != null && newGender.isNotEmpty) {
      requestBody['genero'] = newGender;
    }

    if (requestBody.isEmpty) {
      print('Nenhum dado fornecido para atualização.');
      return false;
    }

    try {
      var response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> updatedUserData = json.decode(response.body);

        // Atualiza as variáveis de estado locais com os novos dados
        _userName = updatedUserData['nome'];
        _userEmail = updatedUserData['email'];
        _userNickname = updatedUserData['apelido'];
        if (updatedUserData['dataNascimento'] != null) {
          _userBirthDate = DateTime.tryParse(updatedUserData['dataNascimento']);
        }
        _userGender = updatedUserData['genero'];

        print('Usuário atualizado com sucesso: Nome: $_userName, Email: $_userEmail, Apelido: $_userNickname');
        notifyListeners();
        return true;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print('Erro de autenticação ao atualizar perfil: ${response.statusCode}');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await _clearUserDataAndLogout(prefs);
        return false;
      } else if (response.statusCode == 400 || response.statusCode == 409) { // Adicionado tratamento para erros de validação
        final Map<String, dynamic> errorData = json.decode(response.body);
        final String errorMessage = errorData['message'] ?? 'Erro de validação ao atualizar perfil.';
        print('Erro de validação: ${response.statusCode} - $errorMessage');
        return false;
      } else {
        print('Erro ao atualizar perfil (Status: ${response.statusCode}): ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro na requisição PUT de atualização de perfil: $e');
      return false;
    }
  }

  Future<void> _clearUserDataAndLogout(SharedPreferences prefs) async {
    await prefs.remove('token');
    _userToken = null;
    _userId = null;
    _userName = null;
    _userEmail = null;
    _userNickname = null;
    _userBirthDate = null;
    _userGender = null;
    notifyListeners();
  }

  Future<void> login(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await loadUserFromToken();
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await _clearUserDataAndLogout(prefs);
  }
}
