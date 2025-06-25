import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starsoul_app/models/history_record.dart';
import 'package:starsoul_app/services/favorites_provider.dart';
import 'package:starsoul_app/services/user_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userToken =
          Provider.of<UserProvider>(context, listen: false).userToken;
      if (userToken != null) {
        Provider.of<FavoritesProvider>(
          context,
          listen: false,
        ).loadFavorites(userToken);
      } else {
        print('Erro: Token do usuário nulo ao carregar favoritos.');
      }
    });
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
      return 'https://img.youtube.com/vi/$videoId/mqdefault.jpg'; // Miniatura de média qualidade
    }
    return null;
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Não foi possível abrir: $url');
    }
  }

  String _getGroupLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final sevenDaysAgo = today.subtract(const Duration(days: 7));
    final thirtyDaysAgo = today.subtract(const Duration(days: 30));

    final adjustedDate = date.subtract(const Duration(days: 1));
    final recordDate = DateTime(
      adjustedDate.year,
      adjustedDate.month,
      adjustedDate.day,
    );

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
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        if (favoritesProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        } else if (favoritesProvider.errorMessage != null) {
          return Center(
            child: Column(
              children: [
                Text(
                  'Erro: ${favoritesProvider.errorMessage}',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  onPressed: () {
                    final userToken =
                        Provider.of<UserProvider>(
                          context,
                          listen: false,
                        ).userToken;
                    if (userToken != null) {
                      favoritesProvider.loadFavorites(
                        userToken,
                      ); // Tenta recarregar
                    }
                  },
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
        } else if (favoritesProvider.favoriteRecords.isEmpty) {
          return const Center(
            child: Text(
              'Nenhum item favorito encontrado.',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          );
        } else {
          // 1. Agrupar os registros por data
          final Map<String, List<HistoryRecord>> groupedRecords = {};
          for (var record in favoritesProvider.favoriteRecords) {
            final label = _getGroupLabel(record.dataUltimoAcesso);
            groupedRecords.putIfAbsent(label, () => []).add(record);
          }

          // 2. Ordenar as chaves dos grupos para exibição (opcional, mas recomendado)
          final List<String> sortedKeys = groupedRecords.keys.toList();
          sortedKeys.sort((a, b) {
            final order = {
              'Hoje': 0,
              'Ontem': 1,
              'Últimos 7 dias': 2,
              'Últimos 30 dias': 3,
              'Mais Antigo': 4,
            };
            return (order[a] ?? 99).compareTo(
              order[b] ?? 99,
            ); // Usa 99 para rótulos desconhecidos
          });

          return ListView.builder(
            itemCount: sortedKeys.length + 1, // Add 1 for the extra text
            itemBuilder: (context, index) {
              if (index < sortedKeys.length) {
                final groupLabel = sortedKeys[index];
                final recordsInGroup = groupedRecords[groupLabel]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        groupLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Column(
                      children:
                      recordsInGroup.map((record) {
                        final content = record.conteudo;
                        final thumbnailUrl = getYoutubeThumbnail(content.url);
                        final String customUrl =
                            'https://starsoul.netlify.app/app/content/${content.id}';

                        return GestureDetector(
                          onTap:
                              () => _launchURL(
                                customUrl,
                              ), // Abre a URL do conteúdo
                          child: Card(
                            color: Colors.white.withOpacity(
                              0.1,
                            ), // Cor de fundo do Card
                            margin: const EdgeInsets.symmetric(
                              vertical: 6.0,
                            ), // Margem entre os Cards, aumentei um pouco
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Container(
                                color: const Color.fromARGB(24, 0, 0, 0),
                                padding: const EdgeInsets.all(0.0),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            0.0,
                                          ),
                                          child:
                                          thumbnailUrl != null
                                              ? Image.network(
                                            thumbnailUrl,
                                            width: 180,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (
                                                context,
                                                error,
                                                stackTrace,
                                                ) =>
                                            const Icon(
                                              Icons.broken_image,
                                              color: Colors.grey,
                                              size: 80,
                                            ), // Ícone maior em caso de erro
                                          )
                                              : Container(
                                            // Placeholder se não houver miniatura
                                            width: 180,
                                            height: 100,
                                            color: Colors.black54,
                                            child: const Icon(
                                              Icons.play_circle_fill,
                                              color: Colors.white70,
                                              size: 60,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top:
                                          2, // Ajuste para posicionar conforme a imagem de referência
                                          left: 2,
                                          child: Container(
                                            width:
                                            35, // <-- Tamanho fixo para o círculo preto (largura)
                                            height: 35,
                                            padding: EdgeInsets.zero,
                                            decoration: const BoxDecoration(
                                              color: Color.fromARGB(
                                                40,
                                                0,
                                                0,
                                                0,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints:
                                              const BoxConstraints(),
                                              icon: Icon(
                                                record.favoritado
                                                    ? Icons.favorite
                                                    : Icons
                                                    .favorite_border,
                                                color: Colors.red,
                                                size: 22,
                                              ),
                                              onPressed: () {
                                                final userToken =
                                                    Provider.of<UserProvider>(
                                                      context,
                                                      listen: false,
                                                    ).userToken;
                                                if (userToken != null) {
                                                  favoritesProvider
                                                      .toggleFavorite(
                                                    userToken,
                                                    content
                                                        .id, // ID do CONTEÚDO
                                                    record
                                                        .favoritado, // Estado atual
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .center, // Alinha horizontalmente ao centro
                                          children: [
                                            Text(
                                              content.titulo,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                              maxLines: 3,
                                              overflow:
                                              TextOverflow.ellipsis,
                                              // textAlign: TextAlign.center, // Removido para alinhar à esquerda
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Stack(
                    alignment: Alignment.center, 
                    children: [
                      Positioned(
                        top: 0,
                        left: 20,
                        child: Icon(Icons.star_rounded, color: Colors.white.withOpacity(0.4), size: 20),
                      ),
                      Positioned(
                        top: 10,
                        right: 30,
                        child: Icon(Icons.star_rounded, color: Colors.white.withOpacity(0.2), size: 14),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 30,
                        child: Icon(Icons.brightness_1_sharp , color: Colors.white.withOpacity(0.3), size: 7),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 70,
                        child: Icon(Icons.star_rounded, color: Colors.white.withOpacity(0.5), size: 18),
                      ),
                      Column( 
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16.0), // Espaçamento antes do texto
                          const Text(
                            'Você favoritou apenas esses itens acima', // Seu texto
                            textAlign: TextAlign.center, // Centraliza o texto horizontalmente
                            style: TextStyle(
                              color: Colors.white70, // Cor cinza claro para o texto
                              fontSize: 12, // Tamanho da fonte (aumentei para 16, estava 12)
                              fontWeight: FontWeight.w400, // Peso da fonte
                            ),
                          ),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}