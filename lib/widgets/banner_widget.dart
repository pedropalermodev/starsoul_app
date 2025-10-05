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
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color.fromARGB(255, 255, 206, 206),
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: const [
              Icon(Icons.error, color: Color.fromARGB(255, 230, 0, 0)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Opa, não conseguimos abrir o link! Verifique se o seu dispositivo tem um navegador instalado (como Chrome ou Safari) e tente de novo.',
                  style: TextStyle(color: Color.fromARGB(255, 230, 0, 0)),
                ),
              ),
            ],
          ),
        ),
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
          height: 120,
        ),
      ),
    );
  }
}
