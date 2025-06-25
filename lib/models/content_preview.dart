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

  factory ContentPreview.fromJson(Map<String, dynamic> json) {
    List<String> parsedCategories = [];
    if (json['categorias'] is List) {
      if (json['categorias'].isNotEmpty && json['categorias'][0] is String) {
        parsedCategories = List<String>.from(json['categorias']);
      } else if (json['categorias'].isNotEmpty &&
          json['categorias'][0] is Map) {
        parsedCategories =
            (json['categorias'] as List)
                .map((catJson) => catJson['categoria']['nome'] as String)
                .toList();
      }
    }

    List<String> parsedTags = [];
    if (json['tags'] is List) {
      parsedTags =
          (json['tags'] as List)
              .map((tagJson) => tagJson['tag']['nome'] as String)
              .toList();
    }

    return ContentPreview(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      descricao: json['descricao'] as String?,
      codStatus: json['codStatus'] as String,
      formato: json['formato'] as String,
      url: json['url'] as String,
      dataPublicacao: DateTime.parse(json['dataPublicacao'] as String),
      categorias: parsedCategories,
      tags: parsedTags,
    );
  }
}
