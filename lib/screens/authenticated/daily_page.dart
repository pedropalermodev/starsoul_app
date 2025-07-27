// lib/pages/daily_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  void _loadNotes() {
    final userToken =
        Provider.of<UserProvider>(context, listen: false).userToken;
    if (userToken != null) {
      Provider.of<DailyProvider>(context, listen: false).loadNotes(userToken);
    }
  }

  // --- Mapeamento de Humor (adicionado para estilizar os itens da lista) ---
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
  // --- Fim do Mapeamento ---

  @override
  Widget build(BuildContext context) {
    return Container(
      // Aplicando o gradiente de fundo ao Container principal da DailyPage
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF3C5DB7), // Cor inicial (azul mais claro)
            Color(0xFF1A2951), // Cor final (azul mais escuro)
          ],
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.only(top: 10.0, bottom: 20.0), // Ajuste conforme necessário
              //       child: ElevatedButton(
              //         onPressed: () async {
              //           await Navigator.of(context).push(
              //             MaterialPageRoute(
              //               builder: (context) => const AnnotationDailyPage(),
              //             ),
              //           );
              //           _loadNotes();
              //         },
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor: const Color(0xFF1A2951),
              //         ),
              //         child: const Text(
              //           'Adicionar nova anotação',
              //           style: TextStyle(color: Colors.white),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),

              // Removido o SizedBox extra aqui se o Padding do botão acima for suficiente.
              // const SizedBox(height: 20,), 

              Expanded(
                // >>>>>> AQUI ESTÁ A MUDANÇA PRINCIPAL <<<<<<
                // Envolve o Consumer em um Builder para obter um BuildContext que não será descartado
                child: Builder(
                  builder: (scaffoldMessengerContext) { // Este context é seguro para ScaffoldMessenger
                    return Consumer<DailyProvider>(
                      builder: (consumerContext, dailyProvider, _) { // Este context é do Consumer
                        if (dailyProvider.isLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (dailyProvider.errorMessage != null) {
                          return Center(child: Text(dailyProvider.errorMessage!));
                        }

                        if (dailyProvider.notes.isEmpty) {
                          return const Center(
                            child: Text(
                              "Nenhuma anotação encontrada. Clique no '+' para adicionar uma.",
                              style: TextStyle(color: Colors.white70, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: dailyProvider.notes.length,
                          itemBuilder: (itemBuilderContext, index) { // Este context é do item individual
                            final note = dailyProvider.notes[index];
                            final moodIcon = _moodIcons[note.humor] ?? Icons.mood_bad;
                            final moodColor = _moodColors[note.humor] ?? Colors.grey;

                            final formattedDate =
                                "${note.dataPublicacao.day.toString().padLeft(2, '0')} de "
                                "${_getMonthName(note.dataPublicacao.month)} de "
                                "${note.dataPublicacao.year}";
                            final formattedTime =
                                "${note.dataPublicacao.hour.toString().padLeft(2, '0')}:"
                                "${note.dataPublicacao.minute.toString().padLeft(2, '0')}";

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0, // Use 16 aqui para alinhar com o padding da page
                                vertical: 8,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(8, 221, 230, 252),
                                  borderRadius: BorderRadius.circular(15.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Icon(moodIcon, color: moodColor, size: 45),
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
                                            final confirm = await showDialog<bool>(
                                              // Use o context do itemBuilder para o showDialog
                                              context: itemBuilderContext, 
                                              builder: (dialogContext) => AlertDialog(
                                                title: const Text('Confirmar Exclusão'),
                                                content: const Text('Tem certeza que deseja deletar esta anotação?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.of(dialogContext).pop(false),
                                                    child: const Text('Cancelar'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () => Navigator.of(dialogContext).pop(true),
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
                                                consumerContext, // Use consumerContext para acessar o provider
                                                listen: false,
                                              ).userToken;
                                              if (userToken != null && note.id != null) {
                                                await dailyProvider.deleteAnnottation(
                                                  note.id!,
                                                  userToken,
                                                );
                                                
                                                // >>>>>> AQUI ESTÁ A MUDANÇA CRÍTICA <<<<<<
                                                // Use o context do Builder (scaffoldMessengerContext) e verifique se está montado
                                                if (mounted) { 
                                                  ScaffoldMessenger.of(scaffoldMessengerContext).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        dailyProvider.errorMessage ?? 'Anotação deletada!',
                                                      ),
                                                      backgroundColor:
                                                          dailyProvider.errorMessage == null
                                                              ? Colors.green
                                                              : Colors.red,
                                                    ),
                                                  );
                                                }
                                                // Recarregue as notas APÓS a exibição do SnackBar (se o widget ainda estiver montado)
                                                _loadNotes(); // Isso fará o setState e reconstruirá a lista
                                              } else {
                                                if (mounted) { // Verifique se está montado
                                                  ScaffoldMessenger.of(scaffoldMessengerContext).showSnackBar(
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

          // Floating Action Button permanece no Stack, como antes
          Positioned(
            bottom: 16.0,
            right: 16.0, // Ajuste para 16 para consistência com o padding da lista
            child: FloatingActionButton(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AnnotationDailyPage(),
                  ),
                );
                _loadNotes();
              },
              backgroundColor: const Color(0xFF3C5DB7),
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
              tooltip: 'Adicionar Anotação',
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