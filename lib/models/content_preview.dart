class ContentPreview {
  final int id;
  final String titulo;
  final String? descricao;
  final String codStatus;
  final String formato;
  final String url;
  final DateTime dataPublicacao;
  final List<String> categorias;
  final List<String> tags;

  ContentPreview({
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

  // Função auxiliar estática para parse flexível de listas
  static List<String> parseStringOrMapList(dynamic jsonList, {String? key1, String? key2}) {
    if (jsonList == null) return [];

    if (jsonList is List) {
      if (jsonList.isEmpty) return [];

      if (jsonList.first is String) {
        // Lista simples de strings
        return List<String>.from(jsonList);
      }

      if (jsonList.first is Map<String, dynamic>) {
        // Lista de mapas, extrai o valor usando as chaves passadas
        return jsonList.map<String>((item) {
          if (key1 != null && key2 != null) {
            return item[key1]?[key2] as String? ?? '';
          } else if (key1 != null) {
            return item[key1] as String? ?? '';
          }
          // Se não souber as chaves, pega a primeira string que encontrar
          return item.values.firstWhere((v) => v is String, orElse: () => '') as String;
        }).where((e) => e.isNotEmpty).toList();
      }
    }

    return [];
  }

  factory ContentPreview.fromJson(Map<String, dynamic> json) {
    return ContentPreview(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      descricao: json['descricao'] as String?,
      codStatus: json['codStatus'] as String,
      formato: json['formato'] as String,
      url: json['url'] as String,
      dataPublicacao: DateTime.parse(json['dataPublicacao'] as String),
      categorias: parseStringOrMapList(json['categorias']),
      tags: parseStringOrMapList(json['tags'], key1: 'tag', key2: 'nome'),
    );
  }
}