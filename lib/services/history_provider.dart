import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:starsoul_app/models/history_record.dart';

class HistoryProvider with ChangeNotifier {
  List<HistoryRecord> _historyRecords = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<HistoryRecord> get historyRecords => _historyRecords;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadHistory(
    String userToken, {
    bool forceRefresh = false,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      if (!forceRefresh) {
        final cacheHistory = prefs.getString('history_cache');
        if (cacheHistory != null) {
          final List<dynamic> jsonList = json.decode(cacheHistory);
          _historyRecords = jsonList.map((json) => HistoryRecord.fromJson(json)).toList();
          print('Histórico carregado do cache! Total: ${_historyRecords.length}');
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      var url = Uri.parse(
        'https://starsoul-backend.onrender.com/api/conteudo-usuario/historico',
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
        _historyRecords = jsonList.map((json) => HistoryRecord.fromJson(json)).toList();
        await prefs.setString('history_cache', json.encode(jsonList));
        print('Histórico carregado da API e salvo no cache! Total: ${_historyRecords.length}');
      } else if (response.statusCode == 400) {
        _errorMessage = 'Sessão expirada. Por favor, faça login novamente.';
        print('Erro de autenticação no histórico: ${response.statusCode}');
      } else {
        _errorMessage =
            'Erro ao carregar histórico: Status ${response.statusCode} - ${response.body}';
        print(_errorMessage);
      }
    } catch (e) {
      _errorMessage = 'Erro na requisição ou decodificação do histórico: $e';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('history_cache');
    print('Cache do histórico limpo.');
  }
}
