import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:starsoul_app/services/content_provider.dart';

class MotivationalPhraseWidget extends StatefulWidget {
  const MotivationalPhraseWidget({super.key});

  @override
  State<MotivationalPhraseWidget> createState() =>
      _MotivationalPhraseWidgetState();
}

class _MotivationalPhraseWidgetState extends State<MotivationalPhraseWidget> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final contentProvider = Provider.of<ContentProvider>(
        context,
        listen: false,
      );
      final phrases = contentProvider.motivationalPhrases;
      if (phrases.isEmpty) return;

      setState(() {
        _currentIndex = (_currentIndex + 1) % phrases.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contentProvider = Provider.of<ContentProvider>(context);
    final phrases = contentProvider.motivationalPhrases;

    if (contentProvider.isLoading) {
      return SizedBox(
        height: 130,
        child: Shimmer.fromColors(
          baseColor: Colors.grey[500]!,
          highlightColor: Colors.grey[600]!,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 1,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 80,
                      width: 352,
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

    if (phrases.isEmpty) {
      return const SizedBox(
        height: 80,
        child: Center(
          child: Text(
            'Nenhuma frase motivacional disponível',
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
          ),
        ),
      );
    }

    final phrase = phrases[_currentIndex].titulo;
    final phraseWithQuotes = '“$phrase”';

    return SizedBox(
      height: 80,
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: (Widget child, Animation<double> animation) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );

            final slideAnimation = Tween<Offset>(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            ).animate(curvedAnimation);

            return FadeTransition(
              opacity: curvedAnimation,
              child: SlideTransition(position: slideAnimation, child: child),
            );
          },

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              phraseWithQuotes,
              key: ValueKey<String>(phraseWithQuotes),
              style: const TextStyle(fontSize: 14, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
