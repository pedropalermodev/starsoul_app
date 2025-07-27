import 'package:flutter/material.dart';

class MoodSelector extends StatefulWidget {
  final String? initialMood;
  final ValueChanged<String> onMoodSelected;

  const MoodSelector({
    Key? key,
    this.initialMood,
    required this.onMoodSelected,
  }) : super(key: key);

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  String _selectedMood = 'Normal'; // Valor padrão

  @override
  void initState() {
    super.initState();
    if (widget.initialMood != null) {
      _selectedMood = widget.initialMood!;
    }
  }

  // Mapeia os valores de humor para ícones e cores
  Map<String, IconData> moodIcons = {
    'Muito ruim': Icons.sentiment_very_dissatisfied,
    'Ruim': Icons.sentiment_dissatisfied,
    'Normal': Icons.sentiment_neutral,
    'Bom': Icons.sentiment_satisfied,
    'Muito bom': Icons.sentiment_very_satisfied,
  };

  Map<String, Color> moodColors = {
    'Muito ruim': Colors.red,
    'Ruim': Colors.orange,
    'Normal': Colors.yellow,
    'Bom': Colors.lightGreen,
    'Muito bom': Colors.green,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: const Color.fromARGB(103, 26, 41, 81), // Cor de fundo do container como na imagem
        borderRadius: BorderRadius.circular(50), // Bordas arredondadas
        border: Border.all(color: Colors.white12), // Uma pequena borda suave
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: moodIcons.keys.map((mood) {
          final isSelected = _selectedMood == mood;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedMood = mood;
              });
              widget.onMoodSelected(mood); // Notifica o widget pai
            },
            child: Column(
              children: [
                Icon(
                  moodIcons[mood],
                  size: 40,
                  color: isSelected ? moodColors[mood] : Colors.grey[600], // Cor do ícone
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}