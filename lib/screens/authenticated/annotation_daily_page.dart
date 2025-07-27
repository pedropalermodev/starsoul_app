// lib/pages/add_daily_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starsoul_app/services/daily_provider.dart';
import 'package:starsoul_app/services/user_provider.dart';
import 'package:starsoul_app/widgets/mood_selector.dart'; // <--- ADICIONE ESTA LINHA

// Certifique-se de que a classe Annotation está acessível.
// Se estiver em um arquivo separado, importe-o:
// import 'package:starsoul_app/services/daily_provider.dart'; // Ou o caminho correto para Annotation

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
          const SnackBar(
            content: Text(
              'Erro: ID do usuário não encontrado. Faça login novamente.',
            ),
          ),
        );
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
        await Provider.of<DailyProvider>(
          context,
          listen: false,
        ).createAnnotation(newAnnotation, userToken);

        if (Provider.of<DailyProvider>(context, listen: false).errorMessage ==
            null) {
          _clearFields();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Anotação criada com sucesso!')),
          );
          // --- Volta para a página anterior após o sucesso ---
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                Provider.of<DailyProvider>(
                  context,
                  listen: false,
                ).errorMessage!,
              ),
            ),
          );
        }
      } catch (e) {
        print('Exceção inesperada ao enviar anotação: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro de conexão: ${e.toString()}')),
        );
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
      backgroundColor: Color(0xFF3C5DB7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3C5DB7),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
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
                  labelStyle: const TextStyle(color: Colors.white),
                  alignLabelWithHint: true,

                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(111, 255, 255, 255),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),

                  // --- Borda quando o campo ESTÁ focado ---
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(111, 255, 255, 255),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(
                      8.0,
                    ),
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
                              ? const CircularProgressIndicator(
                                color: Colors.white,
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
