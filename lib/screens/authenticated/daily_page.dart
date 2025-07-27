// lib/pages/daily_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starsoul_app/screens/authenticated/annotation_daily_page.dart';
import 'package:starsoul_app/services/daily_provider.dart';
import 'package:starsoul_app/services/user_provider.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({super.key});

  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNotes();
    });
  }

  void _loadNotes() {
    final userToken = Provider.of<UserProvider>(context, listen: false).userToken;
    if (userToken != null) {
      Provider.of<DailyProvider>(context, listen: false).loadNotes(userToken);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Expanded(
                child: Consumer<DailyProvider>(
                  builder: (context, dailyProvider, _) {
                    if (dailyProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (dailyProvider.errorMessage != null) {
                      return Center(child: Text(dailyProvider.errorMessage!));
                    }

                    if (dailyProvider.notes.isEmpty) {
                      return const Center(
                        child: Text("Nenhuma anotação encontrada. Clique no '+' para adicionar uma."),
                      );
                    }

                    return ListView.builder(
                      itemCount: dailyProvider.notes.length,
                      itemBuilder: (context, index) {
                        final note = dailyProvider.notes[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                          ),
                          child: Card(
                            elevation: 2,
                            child: ListTile(
                              title: Text(note.humor),
                              subtitle: Text(note.anotacao),
                              trailing: Text(
                                "${note.dataPublicacao.day.toString().padLeft(2, '0')}/"
                                "${note.dataPublicacao.month.toString().padLeft(2, '0')}/"
                                "${note.dataPublicacao.year}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AnnotationDailyPage(),
                  ),
                );
                _loadNotes();
              },
              child: const Icon(Icons.add),
              tooltip: 'Adicionar Anotação',
            ),
          ),
        ],
      ),
    );
  }
}