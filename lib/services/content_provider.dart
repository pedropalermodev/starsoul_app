import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Content {
  final int id;
  final String titulo;
  final String? descricao;
  final String codStatus;
  final String formato;
  final String url;
  final DateTime dataPublicacao;
  final List<String> categorias;
  final List<String> tags;

  Content({
    required this.id,
    required this.titulo,
    this.descricao,
    required this.codStatus,
    required this.formato,
    required this.url,
    required this.dataPublicacao,
    required this.categorias,
    required this.tags,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      descricao: json['descricao'] as String?,
      codStatus: json['codStatus'] as String,
      formato: json['formato'] as String,
      url: json['url'] as String,
      dataPublicacao: DateTime.parse(json['dataPublicacao'] as String),
      categorias: List<String>.from(json['categorias'] as List),
      tags: List<String>.from(json['tags'] as List),
    );
  }
}

class ContentProvider with ChangeNotifier {
  List<Content> _contents = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Content> get contents => _contents;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadContents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      var url = Uri.parse(
        'https://starsoul-backend.onrender.com/api/conteudos/findAll',
      );
      var response = await http.get(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        _contents = jsonList.map((json) => Content.fromJson(json)).toList();
        print('Conteúdos carregados com sucesso! Total: ${_contents.length}');
      } else {
        _errorMessage =
            'Erro ao carregar conteúdos: Status ${response.statusCode} - ${response.body}';
        print(_errorMessage);
      }
    } catch (e) {
      _errorMessage = 'Erro na requisição ou decodificação dos conteúdos: $e';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
