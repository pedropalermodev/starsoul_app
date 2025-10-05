// lib/pages/add_daily_page.dart
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:starsoul_app/services/daily_provider.dart';
import 'package:starsoul_app/services/user_provider.dart';
import 'package:starsoul_app/widgets/mood_selector.dart';

class AnnotationDailyPage extends StatefulWidget {
  const AnnotationDailyPage({super.key});

  @override
  State<AnnotationDailyPage> createState() => _AnnotationDailyPageState();
}

class _AnnotationDailyPageState extends State<AnnotationDailyPage> {
  final _formKey = GlobalKey<FormState>();
  String _humor = 'Normal';
  String _anotacao = '';
  bool _isLoading = false;

  late TextEditingController _anotacaoController;

  @override
  void initState() {
    super.initState();
    _anotacaoController = TextEditingController(text: _anotacao);
  }

  void _clearFields() {
    setState(() {
      _humor = 'Normal';
      _anotacaoController.clear();
      _anotacao = '';
    });
  }

  @override
  void dispose() {
    _anotacaoController.dispose();
    super.dispose();
  }

  void _submitAnnotation(String userToken) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      print('User Token: $userToken');
      print('Humor: $_humor, Anotacao: $_anotacao');

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.userId;

      if (userId == null) {
        setState(() {
          _isLoading = false;
        });
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
                  'Erro: ID do usuário não encontrado. Faça login novamente.',
                  style: TextStyle(color: Color.fromARGB(255, 230, 0, 0)),
                ),
              ),
            ],
          ),
        ),
      );
        Navigator.of(context).pop(false);
        return;
      }

      final newAnnotation = Annotation(
        id: null,
        humor: _humor,
        anotacao: _anotacao,
        dataPublicacao: DateTime.now(),
        usuarioId: userId,
      );

      try {
        final dailyProvider = Provider.of<DailyProvider>(
          context,
          listen: false,
        );

        final createdNote = await dailyProvider.createAnnotation(
          newAnnotation,
          userToken,
        );

        if (createdNote != null) {
          _clearFields();
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Row(
              children: const [
                Icon(
                  Icons.check_circle,
                  color: Color.fromARGB(255, 71, 195, 110),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Anotação registrada com sucesso.',
                    style: TextStyle(color: Color.fromARGB(255, 71, 195, 110)),
                  ),
                ),
              ],
            ),
          ),
        );
          Navigator.of(context).pop(true);
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(dailyProvider.errorMessage!)));
          Navigator.of(context).pop(false);
        }
      } catch (e) {
        print('Exceção inesperada ao enviar anotação: $e');
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color.fromARGB(255, 255, 206, 206),
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              Icon(Icons.error, color: Color.fromARGB(255, 230, 0, 0)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Erro de conexão: ${e.toString()}',
                  style: TextStyle(color: Color.fromARGB(255, 230, 0, 0)),
                ),
              ),
            ],
          ),
        ),
      );
        Navigator.of(context).pop(false);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B4384),

      appBar: AppBar(
        backgroundColor: const Color(0xFF2B4384),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(false),
          padding: const EdgeInsets.only(top: 25, left: 5),
        ),
        title: Container(
          padding: const EdgeInsets.only(top: 25.0),
          child: const Text(
            'Adicionar Anotação',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              Text(
                'Como está seu humor hoje?',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Text(
                'Compartilhe como você se sente neste momento. Seu registro diário ajuda a acompanhar suas emoções, permitindo uma reflexão sobre seu bem-estar ao longo do tempo.',
                style: TextStyle(color: Color(0xFFC2CAE2)),
              ),

              const SizedBox(height: 15),

              MoodSelector(
                initialMood: _humor,
                onMoodSelected: (selectedMood) {
                  setState(() {
                    _humor = selectedMood;
                  });
                },
              ),

              const SizedBox(height: 22),

              Text(
                'Quer adicionar algo sobre o seu dia?',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Text(
                'Escreva um comentário sobre sua experiência hoje. Este espaço, pode ajudar você a refletir sobre o que foi significativo para você.',
                style: TextStyle(color: Color(0xFFC2CAE2)),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _anotacaoController,
                onChanged: (value) {
                  setState(() {
                    _anotacao = value;
                  });
                },
                style: const TextStyle(color: Colors.white, fontSize: 16),
                maxLines: 7,
                decoration: InputDecoration(
                  labelText: 'Escreva aqui sobre seu dia...',
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(73, 255, 255, 255),
                  ),
                  alignLabelWithHint: true,

                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(73, 255, 255, 255),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),

                  // --- Borda quando o campo ESTÁ focado ---
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(73, 255, 255, 255),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, escreva sua anotação';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Botões de Submeter e Limpar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _clearFields,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1A2951),
                      ),
                      child: const Text(
                        'Limpar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          _isLoading
                              ? null
                              : () {
                                final userToken =
                                    Provider.of<UserProvider>(
                                      context,
                                      listen: false,
                                    ).userToken;
                                if (userToken != null) {
                                  _submitAnnotation(userToken);
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1A2951),
                      ),
                      child:
                          _isLoading
                              ? LoadingAnimationWidget.progressiveDots(
                                color: Colors.white,
                                size: 30,
                              )
                              : const Text(
                                'Salvar dia',
                                style: TextStyle(color: Colors.white),
                              ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
