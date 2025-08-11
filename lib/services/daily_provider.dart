import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Annotation {
  final int? id;
  final String humor;
  final String anotacao;
  final DateTime dataPublicacao;
  final int usuarioId;

  Annotation({
    required this.id,
    required this.humor,
    required this.anotacao,
    required this.dataPublicacao,
    required this.usuarioId,
  });

  factory Annotation.fromJson(Map<String, dynamic> json) {
    return Annotation(
      id: json['id'] as int?,
      humor: json['humor'],
      anotacao: json['anotacao'],
      dataPublicacao: DateTime.parse(json['dataPublicacao']),
      usuarioId: json['usuario'] != null ? json['usuario']['id'] as int : 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = {
      'humor': humor,
      'anotacao': anotacao,
      'dataPublicacao': dataPublicacao.toIso8601String(),
      'usuarioId': usuarioId,
    };

    if (id != null) {
      jsonMap['id'] = id;
    }

    return jsonMap;
  }
}

class DailyProvider with ChangeNotifier {
  List<Annotation> _notes = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Annotation> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _saveNotesToCache() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notesJsonList =
        _notes.map((note) => json.encode(note.toJson())).toList();
    await prefs.setStringList('cached_notes', notesJsonList);
  }

  Future<void> _loadNotesFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? notesJsonList = prefs.getStringList('cached_notes');
    if (notesJsonList != null) {
      _notes = notesJsonList.map((noteString) {
        try {
          Map<String, dynamic> noteMap = json.decode(noteString);
          return Annotation.fromJson(noteMap);
        } catch (e) {
          print('Erro ao decodificar anotação do cache: $e');
          // Retorne um objeto vazio ou trate o erro conforme necessário
          return Annotation(
            id: null,
            humor: 'Erro',
            anotacao: 'Erro ao carregar anotação do cache.',
            dataPublicacao: DateTime.now(),
            usuarioId: 0,
          );
        }
      }).toList();
      notifyListeners();
    }
  }

  Future<void> loadNotes(String userToken, {bool forceApiCall = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      
      if (!forceApiCall) {
      await _loadNotesFromCache();
      if (_notes.isNotEmpty) {
        print('Anotações carregadas do cache!');
        _isLoading = false;
        notifyListeners();
        return;
      }
    }

      print('Carregando anotações da API...');

      var url = Uri.parse(
        'https://starsoul-backend.onrender.com/api/anotacoes/me',
      );
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $userToken',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _notes = data.map((e) => Annotation.fromJson(e)).toList();
        await _saveNotesToCache();
        print('Anotações carregados da API e salvos no cache!');
      } else {
        _errorMessage = 'Falha ao carregar anotações: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Erro na requisição ou decodificação das anotações: $e';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Annotation?> createAnnotation(
    Annotation annotation,
    String userToken,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      var url = Uri.parse(
        'https://starsoul-backend.onrender.com/api/anotacoes/cadastrar',
      );
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $userToken',
        },
        body: json.encode(annotation.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final newNote = Annotation.fromJson(json.decode(response.body));
        _notes.add(newNote);
        await _saveNotesToCache();
        print('Anotação criada e salva no cache com sucesso!');
        return newNote;
      } else {
        print(
          'Falha ao criar anotação. Status: ${response.statusCode}, Body: ${response.body}',
        );
        _errorMessage =
            'Falha ao criar anotação: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      _errorMessage = 'Erro na requisição ou decodificação da anotação: $e';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAnnottation(int id, String userToken) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      var url = Uri.parse(
        'https://starsoul-backend.onrender.com/api/anotacoes/$id',
      );
      var response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $userToken',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        _notes.removeWhere((note) => note.id == id);
        await _saveNotesToCache();
        _errorMessage = null;
        print('Anotação com ID $id deletada com sucesso!');
      } else {
        _errorMessage = 'Falha ao deletar anotação: ${response.statusCode}';
        print(
          'Erro ao deletar anotação: Status ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e) {
      _errorMessage = 'Erro ao deletar anotação: $e';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_notes');
    _notes = [];
    notifyListeners();
    print('Cache de anotações limpo com sucesso!');
  }
}
