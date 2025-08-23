// lib/pages/daily_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:starsoul_app/screens/authenticated/annotation_daily_page.dart';
import 'package:starsoul_app/services/daily_provider.dart';
import 'package:starsoul_app/services/user_provider.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({super.key});

  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNotes();
    });
  }

  void _loadNotes({bool forceApiCall = false}) {
    final dailyProvider = Provider.of<DailyProvider>(context, listen: false);
    final userToken =
        Provider.of<UserProvider>(context, listen: false).userToken;
    if (userToken != null) {
      dailyProvider.loadNotes(userToken, forceApiCall: forceApiCall);
    }
  }

  // void _loadNotesFromApi() {
  //   final dailyProvider = Provider.of<DailyProvider>(context, listen: false);
  //   final userToken =
  //       Provider.of<UserProvider>(context, listen: false).userToken;
  //   if (userToken != null) {
  //     dailyProvider.loadNotes(
  //       userToken,
  //       forceApiCall: true,
  //     );
  //   }
  // }

  Map<String, IconData> _moodIcons = {
    'Muito ruim': Icons.sentiment_very_dissatisfied,
    'Ruim': Icons.sentiment_dissatisfied,
    'Normal': Icons.sentiment_neutral,
    'Bom': Icons.sentiment_satisfied,
    'Muito bom': Icons.sentiment_very_satisfied,
  };

  Map<String, Color> _moodColors = {
    'Muito ruim': Colors.red,
    'Ruim': Colors.orange,
    'Normal': Colors.yellow,
    'Bom': Colors.lightGreen,
    'Muito bom': Colors.green,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Builder(
                  builder: (scaffoldMessengerContext) {
                    return Consumer<DailyProvider>(
                      builder: (consumerContext, dailyProvider, _) {
                        if (dailyProvider.isLoading) {
                          return SizedBox(
                            height: 130,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[500]!,
                              highlightColor: Colors.grey[600]!,
                              child: ListView.builder(
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 352,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[700],
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }

                        if (dailyProvider.errorMessage != null) {
                          return Center(
                            child: Text(dailyProvider.errorMessage!),
                          );
                        }

                        if (dailyProvider.notes.isEmpty) {
                          return const Center(
                            child: Text(
                              "Nenhuma anotação encontrada. Clique no '+' para adicionar uma.",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.only(bottom: 140),
                          itemCount: dailyProvider.notes.length,
                          separatorBuilder:
                              (context, index) => const SizedBox(height: 8),
                          itemBuilder: (itemBuilderContext, index) {
                            final note = dailyProvider.notes[index];
                            final moodIcon =
                                _moodIcons[note.humor] ?? Icons.mood_bad;
                            final moodColor =
                                _moodColors[note.humor] ?? Colors.grey;

                            final formattedDate =
                                "${note.dataPublicacao.day.toString().padLeft(2, '0')} de "
                                "${_getMonthName(note.dataPublicacao.month)} de "
                                "${note.dataPublicacao.year}";
                            final formattedTime =
                                "${note.dataPublicacao.hour.toString().padLeft(2, '0')}:"
                                "${note.dataPublicacao.minute.toString().padLeft(2, '0')}";

                            return Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(8, 221, 230, 252),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        moodIcon,
                                        color: moodColor,
                                        size: 45,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              note.humor,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              formattedDate,
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        formattedTime,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () async {
                                          final confirm = await showDialog<
                                            bool
                                          >(
                                            context: itemBuilderContext,
                                            builder:
                                                (dialogContext) => AlertDialog(
                                                  title: const Text(
                                                    'Confirmar Exclusão',
                                                  ),
                                                  content: const Text(
                                                    'Tem certeza que deseja deletar esta anotação?',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed:
                                                          () => Navigator.of(
                                                            dialogContext,
                                                          ).pop(false),
                                                      child: const Text(
                                                        'Cancelar',
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed:
                                                          () => Navigator.of(
                                                            dialogContext,
                                                          ).pop(true),
                                                      child: const Text(
                                                        'Deletar',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          );

                                          if (confirm == true) {
                                            final userToken =
                                                Provider.of<UserProvider>(
                                                  consumerContext,
                                                  listen: false,
                                                ).userToken;

                                            print(
                                              'Tentando deletar anotação...',
                                            );
                                            print('User Token: $userToken');
                                            print('Note ID: ${note.id}');

                                            if (userToken != null &&
                                                note.id != null) {
                                              await dailyProvider
                                                  .deleteAnnottation(
                                                    note.id!,
                                                    userToken,
                                                  );

                                              if (mounted) {
                                                ScaffoldMessenger.of(
                                                  scaffoldMessengerContext,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      dailyProvider
                                                              .errorMessage ??
                                                          'Anotação deletada!',
                                                    ),
                                                    backgroundColor:
                                                        dailyProvider
                                                                    .errorMessage ==
                                                                null
                                                            ? Colors.green
                                                            : Colors.red,
                                                  ),
                                                );
                                              }
                                              _loadNotes();
                                            } else {
                                              if (mounted) {
                                                ScaffoldMessenger.of(
                                                  scaffoldMessengerContext,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Erro: Não foi possível deletar a anotação (token ou ID ausente).',
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          }
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          color: Color.fromARGB(144, 255, 8, 8),
                                          size: 22,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 55.0),
                                    child: Text(
                                      note.anotacao,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 140,
            right: 0,
            child: FloatingActionButton(
              mini: true, // menor tamanho se quiser
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AnnotationDailyPage(),
                  ),
                );
                if (result == true) {
                  _loadNotes(forceApiCall: true);
                }
              },
              backgroundColor: const Color.fromARGB(255, 118, 128, 223),
              foregroundColor: Colors.white,
              child: const Icon(Icons.add), // ícone diferente
              tooltip: 'Botão do topo',
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'janeiro';
      case 2:
        return 'fevereiro';
      case 3:
        return 'março';
      case 4:
        return 'abril';
      case 5:
        return 'maio';
      case 6:
        return 'junho';
      case 7:
        return 'julho';
      case 8:
        return 'agosto';
      case 9:
        return 'setembro';
      case 10:
        return 'outubro';
      case 11:
        return 'novembro';
      case 12:
        return 'dezembro';
      default:
        return '';
    }
  }
}
