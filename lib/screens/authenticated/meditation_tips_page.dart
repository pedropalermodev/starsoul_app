import 'package:flutter/material.dart';

// Este é o ponto de entrada principal da aplicação.
void main() {
  runApp(const MeditationApp());
}

// O widget principal que define a estrutura do aplicativo.
class MeditationApp extends StatelessWidget {
  const MeditationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dicas de Meditação',
      theme: ThemeData(
        fontFamily: 'Inter',
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFEEEEEE)),
          bodyMedium: TextStyle(color: Color(0xFFBBBBBB)),
          titleLarge: TextStyle(color: Color(0xFFE0E0E0)),
          headlineSmall: TextStyle(color: Color(0xFFD9E9F7)),
        ),
      ),
      home: const MeditationTipsPage(),
    );
  }
}

// Dados de modelo para as dicas de meditação.
class MeditationTip {
  final String title;
  final String brief;
  final List<MeditationSubtopic> details;
  final IconData? icon;
  final String heroTag;

  MeditationTip({
    required this.title,
    required this.brief,
    required this.details,
    this.icon,
    required this.heroTag,
  });
}

// Dados de modelo para os sub-tópicos de cada dica.
class MeditationSubtopic {
  final String title;
  final String description;

  MeditationSubtopic({required this.title, required this.description});
}

// A página principal que exibe a lista de dicas com o novo tema.
class MeditationTipsPage extends StatefulWidget {
  const MeditationTipsPage({super.key});

  @override
  State<MeditationTipsPage> createState() => _MeditationTipsPageState();
}

class _MeditationTipsPageState extends State<MeditationTipsPage> {
  // Lista de dicas de meditação.
  final List<MeditationTip> meditationTips = [
    MeditationTip(
      title: 'Encontre o seu lugar',
      brief: 'Um espaço tranquilo para a sua prática.',
      icon: Icons.place,
      heroTag: 'tip-1',
      details: [
        MeditationSubtopic(
          title: 'Defina um espaço sagrado',
          description:
              'Escolha um local na sua casa onde você se sinta confortável e que seja livre de distrações, como um canto do quarto ou um espaço perto de uma janela. O importante é que este local seja exclusivo para a sua meditação, ajudando a sua mente a associar o espaço com a prática.',
        ),
        MeditationSubtopic(
          title: 'Iluminação e ambiente',
          description:
              'Ilumine o espaço com luz natural ou velas para criar um ambiente sereno. Use almofadas, um tapete ou uma cadeira confortável para se sentar. Você pode adicionar elementos como plantas, incenso ou cristais para personalizar o ambiente e torná-lo ainda mais relaxante.',
        ),
      ],
    ),
    MeditationTip(
      title: 'Comece devagar',
      brief: 'Não se cobre para meditar por muito tempo no início.',
      icon: Icons.timer,
      heroTag: 'tip-2',
      details: [
        MeditationSubtopic(
          title: 'A regra dos 5 minutos',
          description:
              'Começar com apenas 5 ou 10 minutos por dia é uma excelente maneira de construir o hábito. Use um cronômetro para manter o controle e, quando ele tocar, simplesmente pare. Lembre-se, o objetivo não é a perfeição, mas a consistência.',
        ),
        MeditationSubtopic(
          title: 'Crie uma rotina diária',
          description:
              'Meditar no mesmo horário todos os dias, seja de manhã ao acordar ou à noite antes de dormir, ajuda a sua mente a se preparar para a prática. A regularidade é o segredo para transformar a meditação em um hábito duradouro.',
        ),
      ],
    ),
    MeditationTip(
      title: 'Foque na sua respiração',
      brief: 'A respiração é a sua âncora durante a meditação.',
      icon: Icons.local_fire_department,
      heroTag: 'tip-3',
      details: [
        MeditationSubtopic(
          title: 'A atenção plena na respiração',
          description:
              'Sente-se confortavelmente, feche os olhos e preste atenção na sua respiração. Sinta o ar fresco entrando pelo seu nariz e o ar morno saindo pela boca. Observe a expansão do seu peito e abdômen a cada inspiração e a sua contração a cada expiração.',
        ),
        MeditationSubtopic(
          title: 'Retornando ao foco',
          description:
              'Quando sua mente divagar e começar a pensar em outras coisas, gentilmente traga o foco de volta para a sua respiração. Este é um exercício de atenção plena que fortalece a sua capacidade de concentração e de estar presente no momento.',
        ),
      ],
    ),
    MeditationTip(
      title: 'Seja gentil com a sua mente',
      brief: 'Pensamentos vão e vêm, e isso é completamente normal.',
      icon: Icons.favorite,
      heroTag: 'tip-4',
      details: [
        MeditationSubtopic(
          title: 'Observando os pensamentos como nuvens',
          description:
              'Não se frustre se sua mente for para outros lugares. O objetivo não é parar de pensar, mas sim observar os pensamentos sem julgamento. Imagine que os pensamentos são como nuvens passando no céu; reconheça a sua presença, mas deixe-os seguir o seu caminho.',
        ),
        MeditationSubtopic(
          title: 'A prática do não-julgamento',
          description:
              'A prática de meditação nos ensina a não nos apegarmos aos nossos pensamentos, emoções e julgamentos. Aceite que eles existem, mas não se identifique com eles. Permita que a sua mente se acalme naturalmente ao invés de forçá-la a ficar quieta.',
        ),
      ],
    ),
    MeditationTip(
      title: 'Utilize guias de meditação',
      brief: 'Guias podem ajudar a manter a concentração.',
      icon: Icons.library_books,
      heroTag: 'tip-5',
      details: [
        MeditationSubtopic(
          title: 'Recursos para iniciantes',
          description:
              'Existem diversos aplicativos e vídeos com meditações guiadas que podem ser muito úteis, principalmente para iniciantes. A voz do guia pode ajudar a direcionar a sua atenção e a manter o foco, além de ensinar novas técnicas e abordagens, como a meditação da bondade amorosa ou a varredura corporal.',
        ),
        MeditationSubtopic(
          title: 'Experimente e encontre o seu estilo',
          description:
              'Experimente diferentes guias, vozes e estilos de meditação para encontrar aquele que mais se adapta a você. A diversidade de técnicas é enorme, e encontrar a que te agrada mais pode fazer toda a diferença na sua prática diária.',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF233A66),
      body: Stack(
        children: [
          Positioned(
            bottom: 50,
            left: -100,
            child: StarryLight(size: 140, color: Colors.cyan.withOpacity(0.1)),
          ),
          Positioned(
            top: 59,
            right: -100,
            child: StarryLight(size: 210, color: Colors.purple.withOpacity(0.1)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Jornada Estelar',
                    style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: Color(0xFFD9E9F7),
                    ),
                  ),
                  const Text(
                    'Explore o seu universo interior e encontre a paz.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFBBBBBB),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Lista de cards das dicas com o novo design.
                  Column(
                    children: meditationTips.map((tip) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: TipCard(
                          tip: tip,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MeditationTipDetailsPage(tip: tip),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget personalizado para criar os pontos de luz no fundo.
class StarryLight extends StatelessWidget {
  final double size;
  final Color color;

  const StarryLight({
    super.key,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size / 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: size / 4,
            spreadRadius: size / 8,
          ),
        ],
      ),
    );
  }
}

// Widget de card para cada dica, com um visual de planeta/estrela.
class TipCard extends StatelessWidget {
  final MeditationTip tip;
  final VoidCallback onTap;

  const TipCard({super.key, required this.tip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tip.heroTag,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Ícone com brilho sutil.
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [const Color(0xFF673AB7), const Color(0xFF9575CD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF673AB7).withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    tip.icon ?? Icons.question_mark,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip.title,
                        maxLines: 1, // Impede que o texto ultrapasse uma linha
                        overflow: TextOverflow.ellipsis, // Adiciona '...' se o texto for muito longo
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD9E9F7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tip.brief,
                        maxLines: 2, // Impede que o texto ultrapasse duas linhas
                        overflow: TextOverflow.ellipsis, // Adiciona '...' se o texto for muito longo
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFFBBBBBB),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFFBBBBBB),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// A nova página de detalhes com o tema cósmico.
class MeditationTipDetailsPage extends StatelessWidget {
  final MeditationTip tip;

  const MeditationTipDetailsPage({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Fundo com estrelas e gradiente.
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D1B2A), Color(0xFF1B263B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Pontos de luz no fundo.
          Positioned(
            top: -50,
            right: -50,
            child: StarryLight(size: 200, color: Colors.cyan.withOpacity(0.1)),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: StarryLight(size: 250, color: Colors.purple.withOpacity(0.1)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // Ícone com animação Hero.
                  Hero(
                    tag: tip.heroTag,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [const Color(0xFF673AB7).withOpacity(0.9), const Color(0xFF512DA8).withOpacity(0.9)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF673AB7).withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        tip.icon ?? Icons.question_mark,
                        color: Colors.white,
                        size: 64,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    tip.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD9E9F7),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tip.brief,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFFBBBBBB),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Cards para os sub-tópicos
                  Column(
                    children: tip.details.map((subtopic) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                subtopic.title,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFD9E9F7),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                subtopic.description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.6,
                                  color: Color(0xFFEEEEEE),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3949AB).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFF5C6BC0)),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Color(0xFFD9E9F7),
                          size: 30,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Lembre-se: A meditação é uma jornada, não um destino. Cada pequena prática conta!',
                            style: TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFFBBBBBB),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
