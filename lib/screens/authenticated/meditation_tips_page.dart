import 'package:flutter/material.dart';

// Esta é a página principal que exibe as dicas de meditação.
class MeditationTipsPage extends StatefulWidget {
  const MeditationTipsPage({super.key});

  @override
  State<MeditationTipsPage> createState() => _MeditationTipsPageState();
}

class _MeditationTipsPageState extends State<MeditationTipsPage> {
  // Lista de dicas de meditação. Cada item tem um título, uma breve descrição,
  // detalhes completos e um ícone para representá-lo.
  final List<MeditationTip> meditationTips = [
    MeditationTip(
      title: 'Encontre o seu lugar',
      brief: 'Um espaço tranquilo é fundamental para a sua prática.',
      icon: Icons.place,
      details: [
        MeditationSubtopic(
          title: 'Defina um espaço sagrado',
          description: 'Escolha um local na sua casa onde você se sinta confortável e que seja livre de distrações, como um canto do quarto ou um espaço perto de uma janela. O importante é que este local seja exclusivo para a sua meditação, ajudando a sua mente a associar o espaço com a prática.',
        ),
        MeditationSubtopic(
          title: 'Iluminação e ambiente',
          description: 'Ilumine o espaço com luz natural ou velas para criar um ambiente sereno. Use almofadas, um tapete ou uma cadeira confortável para se sentar. Você pode adicionar elementos como plantas, incenso ou cristais para personalizar o ambiente e torná-lo ainda mais relaxante.',
        ),
      ],
    ),
    MeditationTip(
      title: 'Comece devagar',
      brief: 'Não se cobre para meditar por muito tempo no início.',
      icon: Icons.timer,
      details: [
        MeditationSubtopic(
          title: 'A regra dos 5 minutos',
          description: 'Começar com apenas 5 ou 10 minutos por dia é uma excelente maneira de construir o hábito. Use um cronômetro para manter o controle e, quando ele tocar, simplesmente pare. Lembre-se, o objetivo não é a perfeição, mas a consistência.',
        ),
        MeditationSubtopic(
          title: 'Crie uma rotina diária',
          description: 'Meditar no mesmo horário todos os dias, seja de manhã ao acordar ou à noite antes de dormir, ajuda a sua mente a se preparar para a prática. A regularidade é o segredo para transformar a meditação em um hábito duradouro.',
        ),
      ],
    ),
    MeditationTip(
      title: 'Foque na sua respiração',
      brief: 'A respiração é a sua âncora durante a meditação.',
      icon: Icons.local_fire_department,
      details: [
        MeditationSubtopic(
          title: 'A atenção plena na respiração',
          description: 'Sente-se confortavelmente, feche os olhos e preste atenção na sua respiração. Sinta o ar fresco entrando pelo seu nariz e o ar morno saindo pela boca. Observe a expansão do seu peito e abdômen a cada inspiração e a sua contração a cada expiração.',
        ),
        MeditationSubtopic(
          title: 'Retornando ao foco',
          description: 'Quando sua mente divagar e começar a pensar em outras coisas, gentilmente traga o foco de volta para a sua respiração. Este é um exercício de atenção plena que fortalece a sua capacidade de concentração e de estar presente no momento.',
        ),
      ],
    ),
    MeditationTip(
      title: 'Seja gentil com a sua mente',
      brief: 'Pensamentos vão e vêm, e isso é completamente normal.',
      icon: Icons.favorite,
      details: [
        MeditationSubtopic(
          title: 'Observando os pensamentos como nuvens',
          description: 'Não se frustre se sua mente for para outros lugares. O objetivo não é parar de pensar, mas sim observar os pensamentos sem julgamento. Imagine que os pensamentos são como nuvens passando no céu; reconheça a sua presença, mas deixe-os seguir o seu caminho.',
        ),
        MeditationSubtopic(
          title: 'A prática do não-julgamento',
          description: 'A prática de meditação nos ensina a não nos apegarmos aos nossos pensamentos, emoções e julgamentos. Aceite que eles existem, mas não se identifique com eles. Permita que a sua mente se acalme naturalmente ao invés de forçá-la a ficar quieta.',
        ),
      ],
    ),
    MeditationTip(
      title: 'Utilize guias de meditação',
      brief: 'Guias podem ajudar a manter a concentração.',
      icon: Icons.library_books,
      details: [
        MeditationSubtopic(
          title: 'Recursos para iniciantes',
          description: 'Existem diversos aplicativos e vídeos com meditações guiadas que podem ser muito úteis, principalmente para iniciantes. A voz do guia pode ajudar a direcionar a sua atenção e a manter o foco, além de ensinar novas técnicas e abordagens, como a meditação da bondade amorosa ou a varredura corporal.',
        ),
        MeditationSubtopic(
          title: 'Experimente e encontre o seu estilo',
          description: 'Experimente diferentes guias, vozes e estilos de meditação para encontrar aquele que mais se adapta a você. A diversidade de técnicas é enorme, e encontrar a que te agrada mais pode fazer toda a diferença na sua prática diária.',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A237E), // Fundo azul escuro.
      body: Stack(
        children: [
          // Camada de decorações de nuvens no topo como um banner.
          
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  // Título e subtítulo.
                  const Text(
                    'Dicas de Meditação',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFE0E0E0),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 32.0),
                    child: Text(
                      'Toque em uma dica para ver mais detalhes e aprender a aprimorar sua prática.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFBBBBBB), // Cor do texto clara.
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  // Lista de dicas, agora com navegação.
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: meditationTips.length,
                    itemBuilder: (context, index) {
                      final tip = meditationTips[index];
                      // Adiciona um espaçamento maior para o último item conforme solicitado.
                      return Padding(
                        padding: EdgeInsets.only(bottom: index == meditationTips.length - 1 ? 140.0 : 20.0),
                        child: TipCard(
                          tip: tip,
                          onTap: () {
                            // Navega para a nova página de detalhes.
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MeditationTipDetailsPage(tip: tip),
                              ),
                            );
                          },
                        ),
                      );
                    },
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

// Widget de card de dica simplificado para navegação.
class TipCard extends StatelessWidget {
  final MeditationTip tip;
  final VoidCallback onTap;

  const TipCard({super.key, required this.tip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Card(
        color: Colors.white.withOpacity(0.1), // Cor do card mais transparente para combinar com o fundo escuro.
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF673AB7), // Roxo para contraste.
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF673AB7).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(tip.icon ?? Icons.question_mark, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tip.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEEEEEE), // Cor do texto clara.
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        tip.brief,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFBBBBBB),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Color(0xFFBBBBBB)),
            ],
          ),
        ),
      ),
    );
  }
}

// Classe de modelo para as dicas.
class MeditationTip {
  final String title;
  final String brief;
  final List<MeditationSubtopic> details;
  final IconData? icon;

  MeditationTip({
    required this.title,
    required this.brief,
    required this.details,
    this.icon,
  });
}

// Nova classe para representar um sub-tópico.
class MeditationSubtopic {
  final String title;
  final String description;

  MeditationSubtopic({
    required this.title,
    required this.description,
  });
}

// Nova página para exibir os detalhes da dica de meditação.
class MeditationTipDetailsPage extends StatelessWidget {
  final MeditationTip tip;

  const MeditationTipDetailsPage({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A237E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Decorações de nuvem de fundo para a página de detalhes.
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF5C6BC0).withOpacity(0.8),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                color: const Color(0xFF9FA8DA).withOpacity(0.6),
                borderRadius: BorderRadius.circular(125),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // Ícone decorativo com design mais detalhado.
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF673AB7).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF673AB7).withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(tip.icon ?? Icons.question_mark, color: Colors.white, size: 64),
                  ),
                  const SizedBox(height: 32),
                  // Título principal.
                  Text(
                    tip.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFEEEEEE),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Subtítulo da dica.
                  Text(
                    tip.brief,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFFBBBBBB),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Cards para os sub-tópicos
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: tip.details.length,
                    itemBuilder: (context, index) {
                      final subtopic = tip.details[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Card(
                          color: Colors.white.withOpacity(0.1),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subtopic.title,
                                  style: const TextStyle(
                                    fontSize: 16,
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
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  // Exemplo de um elemento extra para um design mais rico.
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3949AB),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFF5C6BC0)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Color(0xFFD9E9F7), size: 30),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Lembre-se: A meditação é uma jornada, não um destino. Cada pequena prática conta!',
                            style: TextStyle(
                              fontSize: 14,
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
