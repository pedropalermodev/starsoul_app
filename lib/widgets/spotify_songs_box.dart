import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:starsoul_app/services/content_provider.dart';

class SpotifySongsWidget extends StatelessWidget {
  const SpotifySongsWidget({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Não foi possível abrir a URL: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final contentProvider = Provider.of<ContentProvider>(context);
    final spotifySongs = contentProvider.spotifySongs;

    if (contentProvider.isLoading) {
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
                      height: 60,
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
    }

    if (spotifySongs.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(child: Text('Nenhuma música disponível', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12 ))),
      );
    }

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: spotifySongs.length,
        itemBuilder: (context, index) {
          final song = spotifySongs[index];
          return GestureDetector(
            onTap: () => _launchURL(song.url),
            child: Container(
              width: 170,
              margin: const EdgeInsets.only(right: 10),
              // só colocamos borderRadius na imagem, então container fica sem decoração
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      'https://blog.trocafone.com/wp-content/uploads/2019/12/spotify.blog_-1200x640.jpg',
                      height: 60,
                      width: 170,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            height: 60,
                            width: 170,
                            color:
                                Colors.grey[800], // fundo escuro para fallback
                            child: const Icon(
                              Icons.music_note,
                              color: Colors.white70,
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      song.titulo,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start, // alinhamento à esquerda
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
