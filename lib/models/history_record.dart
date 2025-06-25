import 'package:starsoul_app/models/content_preview.dart';

class HistoryRecord {
  final int id;
  final ContentPreview conteudo;
  final bool favoritado;
  final DateTime dataUltimoAcesso;
  final int numeroVisualizacoes;

  HistoryRecord({
    required this.id,
    required this.conteudo,
    required this.favoritado,
    required this.dataUltimoAcesso,
    required this.numeroVisualizacoes,
  });

  factory HistoryRecord.fromJson(Map<String, dynamic> json) {
    return HistoryRecord(
      id: json['id'] as int,
      conteudo: ContentPreview.fromJson(
        json['conteudo'] as Map<String, dynamic>,
      ),
      favoritado: json['favoritado'] as bool,
      dataUltimoAcesso: DateTime.parse(json['dataUltimoAcesso'] as String),
      numeroVisualizacoes: json['numeroVisualizacoes'] as int,
    );
  }
}
