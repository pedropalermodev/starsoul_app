import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:starsoul_app/models/history_record.dart';

class FavoritesProvider with ChangeNotifier {
  List<HistoryRecord> _favoriteRecords = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<HistoryRecord> get favoriteRecords => _favoriteRecords;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadFavorites(String userToken) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      var url = Uri.parse(
        'https://starsoul-backend.onrender.com/api/conteudo-usuario/favoritos',
      );
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $userToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        _favoriteRecords =
            jsonList.map((json) => HistoryRecord.fromJson(json)).toList();
        print(
          'Favoritos carregados com sucesso! Total: ${_favoriteRecords.length}',
        );
      } else if (response.statusCode == 400) {
        _errorMessage = 'Sessão expirada. Por favorm faça login novamente.';
        print('Erro de autenticação nos favoritos: ${response.statusCode}');
      } else {
        _errorMessage =
            'Erro ao carregar favoritos: Status ${response.statusCode}';
        print(_errorMessage);
      }
    } catch (e) {
      _errorMessage = 'Erro na requisição ou decodificação dos favoritos: $e';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(
    String userToken,
    int conteudoId,
    bool isCurrentlyFavorite,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final String endpoint =
          isCurrentlyFavorite ? '/desfavoritar' : '/favoritar';
      var url = Uri.parse(
        'https://starsoul-backend.onrender.com/api/conteudo-usuario/$conteudoId$endpoint',
      ); // Monta a URL correta

      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $userToken',
        },
        body: json.encode({}),
      );

      if (response.statusCode == 200) {
        await loadFavorites(userToken);
        print(
          'Status de favorito atualizado para $conteudoId: ${!isCurrentlyFavorite}',
        );
      } else if (response.statusCode == 401) {
        _errorMessage = 'Sessão expirada. Por favor, faça login novamente.';
        print(
          'Erro de autenticação ao alternar favorito: ${response.statusCode}',
        );
      } else {
        _errorMessage =
            'Erro ao alternar favorito: Status ${response.statusCode} - ${response.body}';
        print(_errorMessage);
      }
    } catch (e) {
      _errorMessage = 'Erro ao alternar favorito: $e';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
