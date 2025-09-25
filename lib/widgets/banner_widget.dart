import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerWidget extends StatelessWidget {
  final String assetPath; // caminho da imagem no assets
  final String linkUrl; // rota para navegar

  const BannerWidget({
    super.key,
    required this.assetPath,
    required this.linkUrl,
  });

  Future<void> _launchUrl(BuildContext context) async {
    final Uri uri = Uri.parse(linkUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Não foi possível abrir o link")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchUrl(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 110,
        ),
      ),
    );
  }
}
