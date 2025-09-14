import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:starsoul_app/models/history_record.dart';
import 'package:starsoul_app/services/history_provider.dart';
import 'package:starsoul_app/services/user_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userToken =
          Provider.of<UserProvider>(context, listen: false).userToken;
      if (userToken != null) {
        Provider.of<HistoryProvider>(
          context,
          listen: false,
        ).loadHistory(userToken);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkAuth();
  }

  void _checkAuth() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (!userProvider.isAuthenticated) {
      Future.microtask(() {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/welcome', (route) => false);
      });
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  String? getYoutubeThumbnail(String videoUrl) {
    final uri = Uri.tryParse(videoUrl);
    if (uri == null) {
      return null;
    }

    String? videoId;
    if (uri.host == 'www.youtube.com' ||
        uri.host == 'youtube.com' ||
        uri.host == 'youtu.be2') {
      if (uri.queryParameters.containsKey('v')) {
        videoId = uri.queryParameters['v'];
      } else {
        final segments = uri.pathSegments;
        if (segments.isNotEmpty &&
            (segments.first == 'embed' || segments.first == 'v')) {
          videoId = segments.last;
        }
      }
    } else if (uri.host == 'youtu.be') {
      // youtu.be
      final segments = uri.pathSegments;
      if (segments.isNotEmpty) {
        videoId = segments.first;
      }
    }

    if (videoId != null && videoId.isNotEmpty) {
      return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
    }
    return null;
  }

  String _getGroupLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final sevenDaysAgo = today.subtract(const Duration(days: 7));
    final thirtyDaysAgo = today.subtract(const Duration(days: 30));

    // Ajusta a data do registro para comparar apenas dia, mês e ano
    final recordDate = DateTime(date.year, date.month, date.day);

    if (recordDate.isAtSameMomentAs(today)) {
      return 'Hoje';
    } else if (recordDate.isAtSameMomentAs(yesterday)) {
      return 'Ontem';
    } else if (recordDate.isAfter(sevenDaysAgo)) {
      return 'Últimos 7 dias';
    } else if (recordDate.isAfter(thirtyDaysAgo)) {
      return 'Últimos 30 dias';
    } else {
      return 'Mais Antigo';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3C5DB7),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
          padding: const EdgeInsets.only(top: 25, left: 5),
        ),
        title: Container(
          padding: const EdgeInsets.only(top: 25.0),
          child: const Text(
            'Histórico',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        // actions: [
        //   IconButton(
        //     padding: const EdgeInsets.only(top: 22.0, right: 5.0),
        //     icon: const Icon(Icons.delete, color: Colors.white),
        //     onPressed: () async {
        //       final confirm = await showDialog<bool>(
        //         context: context,
        //         builder:
        //             (context) => AlertDialog(
        //               title: const Text('Confirmar exclusão'),
        //               content: const Text(
        //                 'Deseja realmente apagar todo o histórico?',
        //               ),
        //               actions: [
        //                 TextButton(
        //                   onPressed: () => Navigator.of(context).pop(false),
        //                   child: const Text('Cancelar'),
        //                 ),
        //                 TextButton(
        //                   onPressed: () => Navigator.of(context).pop(true),
        //                   child: const Text('Apagar'),
        //                 ),
        //               ],
        //             ),
        //       );

        //       if (confirm == true) {
        //         final userToken =
        //             Provider.of<UserProvider>(context, listen: false).userToken;
        //         if (userToken != null) {
        //           await Provider.of<HistoryProvider>(
        //             context,
        //             listen: false,
        //           ).deleteHistory(userToken);
        //         }
        //       }
        //     },
        //   ),
        // ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3C5DB7), Color(0xFF1A2951)],
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Consumer<HistoryProvider>(
                  builder: (context, historyProvider, child) {
                    // Função para recarregar os dados
                    Future<void> _refreshHistory() async {
                      final userToken =
                          Provider.of<UserProvider>(
                            context,
                            listen: false,
                          ).userToken;
                      if (userToken != null) {
                        await historyProvider.loadHistory(
                          userToken,
                          forceRefresh: true,
                        );
                      }
                    }

                    if (historyProvider.isLoading) {
                      return Center(
                        child: LoadingAnimationWidget.progressiveDots(
                          color: Colors.white,
                          size: 30,
                        ),
                      );
                    } else if (historyProvider.errorMessage != null) {
                      return Center(
                        child: Text(
                          'Erro: ${historyProvider.errorMessage}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      );
                    } else if (historyProvider.historyRecords.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: _refreshHistory,
                        color: Colors.white,
                        backgroundColor: const Color(0xFF3C5DB7),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height:
                                MediaQuery.of(context).size.height -
                                kToolbarHeight,
                            child: const Center(
                              child: Text(
                                'Nenhum histórico de visualização recente.',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      final Map<String, List<HistoryRecord>> groupedRecords =
                          {};
                      for (var record in historyProvider.historyRecords) {
                        final label = _getGroupLabel(record.dataUltimoAcesso);
                        groupedRecords.putIfAbsent(label, () => []).add(record);
                      }

                      final List<String> sortedKeys =
                          groupedRecords.keys.toList();
                      sortedKeys.sort((a, b) {
                        final order = {
                          'Hoje': 0,
                          'Ontem': 1,
                          'Últimos 7 dias': 2,
                          'Últimos 30 dias': 3,
                          'Mais Antigo': 4,
                        };
                        return (order[a] ?? 99).compareTo(order[b] ?? 99);
                      });

                      return RefreshIndicator(
                        onRefresh: _refreshHistory,
                        color: const Color.fromARGB(255, 82, 97, 146),
                        backgroundColor: Colors.white,
                        child: ListView.builder(
                          itemCount: sortedKeys.length,
                          itemBuilder: (context, index) {
                            final groupLabel = sortedKeys[index];
                            final recordsInGroup = groupedRecords[groupLabel]!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 4.0,
                                  ),
                                  child: Text(
                                    groupLabel,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: recordsInGroup.length,
                                  itemBuilder: (context, itemIndex) {
                                    final record =
                                        recordsInGroup.reversed
                                            .toList()[itemIndex];
                                    final content = record.conteudo;
                                    final thumbnailUrl = getYoutubeThumbnail(
                                      content.url,
                                    );
                                    final userToken =
                                        Provider.of<UserProvider>(
                                          context,
                                          listen: false,
                                        ).userToken;
                                    final String customUrl =
                                        'https://starsoul.netlify.app/app/content/${content.id}?authToken=$userToken';

                                    return GestureDetector(
                                      onTap: () => _launchURL(customUrl),
                                      child: Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 6.0,
                                          horizontal: 20.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            15.0,
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            if (thumbnailUrl != null)
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Image.network(
                                                  thumbnailUrl,
                                                  width: 180,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) => const Icon(
                                                        Icons.broken_image,
                                                        color: Colors.grey,
                                                        size: 70,
                                                      ),
                                                ),
                                              )
                                            else
                                              Container(
                                                width: 180,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[700],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        8.0,
                                                      ),
                                                ),
                                                child: const Icon(
                                                  Icons.play_circle_fill,
                                                  color: Colors.white70,
                                                  size: 40,
                                                ),
                                              ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    content.titulo,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Visto em: ${record.dataUltimoAcesso.day}/${record.dataUltimoAcesso.month}/${record.dataUltimoAcesso.year} ${record.dataUltimoAcesso.hour.toString().padLeft(2, '0')}:${record.dataUltimoAcesso.minute.toString().padLeft(2, '0')}',
                                                    style: const TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
