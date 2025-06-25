import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starsoul_app/services/history_provider.dart';
import 'package:starsoul_app/services/user_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    if (uri.host.contains('youtube.com') || uri.host.contains('youtu.be')) {
      if (uri.queryParameters.containsKey('v')) {
        videoId = uri.queryParameters['v'];
      } else {
        final segments = uri.pathSegments;
        if (segments.isNotEmpty) {
          videoId = segments.last;
        }
      }
    }

    if (videoId != null && videoId.isNotEmpty) {
      return 'https://img.youtube.com/vi/$videoId/mqdefault.jpg';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Olá, ${userProvider.userName?.split(' ').first ?? 'Usuário'}!',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        const Text(
          'Acesse seu histórico, diário e inspirações do dia.',
          style: TextStyle(color: Color(0xFFCDCDCD)),
        ),

        const SizedBox(height: 30),

        const Text(
          'Seu histórico de visualização recente.',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),

        SizedBox(
          height: 150,
          child: Consumer<HistoryProvider>(
            builder: (context, historyProvider, child) {
              if (historyProvider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              } else if (historyProvider.errorMessage != null) {
                return Center(
                  child: Text(
                    'Erro: ${historyProvider.errorMessage}',
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                );
              } else if (historyProvider.historyRecords.isEmpty) {
                return const Center(
                  child: Text(
                    'Nenhum histórico de visualização recente.',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                );
              } else {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: historyProvider.historyRecords.length,
                  itemBuilder: (context, index) {
                    final record = historyProvider.historyRecords[index];
                    final content = record.conteudo;
                    final thumbnailUrl = getYoutubeThumbnail(content.url);
                    final String customUrl =
                        'https://starsoul.netlify.app/app/content/${content.id}';

                    return GestureDetector(
                      onTap: () => _launchURL(customUrl),
                      child: Container(
                        width: 170,
                        margin: const EdgeInsets.only(right: 10.0),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (thumbnailUrl != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  8.0,
                                ),
                                child: Image.network(
                                  thumbnailUrl,
                                  width: 170,
                                  height: 95,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(
                                            Icons.broken_image,
                                            color: Colors.grey,
                                          ),
                                ),
                              )
                            else
                              const Icon(
                                Icons.play_circle_fill,
                                color: Colors.white70,
                                size: 40,
                              ),
                            const SizedBox(height: 4),
                            Text(
                              content.titulo,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
