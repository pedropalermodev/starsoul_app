import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:starsoul_app/models/content_preview.dart';

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
  List<ContentPreview> _contentsPreview = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ContentPreview> get contentsPreview => _contentsPreview;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<ContentPreview> get motivationalPhrases {
    return _contentsPreview.where((content) {
      final hasTag = content.tags.contains('Frases motivacionais');
      final isActive = content.codStatus == 'Ativo';
      final isTextFormat = content.formato == 'Texto';
      return isActive && isTextFormat && hasTag;
    }).toList();
  }

  List<ContentPreview> get spotifySongs {
    return _contentsPreview.where((content) {
      final isActive = content.codStatus == 'Ativo';
      final isTextFormat = content.formato == 'Audio';
      return isActive && isTextFormat;
    }).toList();
  }

  Future<void> loadContents({ bool forceRefresh = false, }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      if (!forceRefresh) {
        final cacheContents = prefs.getString('contents_cache');
        if (cacheContents != null) {
          final List<dynamic> jsonList = json.decode(cacheContents);
          _contentsPreview = jsonList.map((json) => ContentPreview.fromJson(json)).toList();
          print('Conteúdos carregado do cache! Total: ${_contentsPreview.length}');
          _isLoading = false;
          notifyListeners();
          return;
        }
      }
      
      var url = Uri.parse(
        'https://starsoul-backend.onrender.com/api/conteudos/findAll',
      );
      var response = await http.get(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        _contentsPreview = jsonList.map((json) => ContentPreview.fromJson(json)).toList();
        print('Conteúdos carregados da API e salvo no cache! Total: ${_contentsPreview.length}');

        // Salva no cache
        await prefs.setString('contents_cache', json.encode(jsonList));

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

void clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('contents_cache');
    print('Cache do conteúdo limpo.');
  }
