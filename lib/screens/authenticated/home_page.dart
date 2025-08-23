import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starsoul_app/services/content_provider.dart';
import 'package:starsoul_app/services/history_provider.dart';
import 'package:starsoul_app/services/user_provider.dart';
import 'package:starsoul_app/widgets/motivational_box.dart';
import 'package:starsoul_app/widgets/spotify_songs_box.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart';

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

      Provider.of<ContentProvider>(context, listen: false).loadContents();
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
                return SizedBox(
                  height: 130,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[500]!,
                    highlightColor: Colors.grey[600]!,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 170,
                          margin: EdgeInsets.only(right: index == 1 ? 0 : 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 95,
                                decoration: BoxDecoration(
                                  color: Colors.grey[600],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.grey[600],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
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
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
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
                    final token = userProvider.userToken;
                    final String customUrl = 'https://starsoul.netlify.app/app/content/${content.id}?authToken=$token';

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
                                borderRadius: BorderRadius.circular(8.0),
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
                              Container(
                                width: 170,
                                height: 95,
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.white70,
                                  size: 40,
                                ),
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

        const SizedBox(height: 8),

        Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 33, 58, 102),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(child: const MotivationalPhraseWidget()),
        ),

        const SizedBox(height: 18),

        const Text(
          'Nossa curadoria especial de playlists para você.',
          style: TextStyle(color: Colors.white),
        ),

        Column(
          children: [const SizedBox(height: 10), const SpotifySongsWidget()],
        ),
      ],
    );
  }
}
