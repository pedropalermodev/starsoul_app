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
    this.id,
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
    return {
      'humor': humor,
      'anotacao': anotacao,
      'dataPublicacao': dataPublicacao.toIso8601String(),
      'usuarioId': usuarioId,
    };
  }
}

class DailyProvider with ChangeNotifier {
  List<Annotation> _notes = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Annotation> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadNotes(String userToken) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
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

  Future<void> createAnnotation(Annotation annotation, String userToken) async {
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
        _notes.add(Annotation.fromJson(json.decode(response.body)));
        print('Anotação criada e recebida do backend com sucesso: ${response.body}',);
      } else {
        print('Falha ao criar anotação. Status: ${response.statusCode}, Body: ${response.body}',);
        _errorMessage = 'Falha ao criar anotação: ${response.statusCode} - ${response.body}';
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
        _errorMessage = null; // Limpa qualquer erro anterior
        print('Anotação com ID $id deletada com sucesso!');
      } else {
        _errorMessage = 'Falha ao deletar anotação: ${response.statusCode}';
        print('Erro ao deletar anotação: Status ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      _errorMessage = 'Erro ao deletar anotação: $e';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
