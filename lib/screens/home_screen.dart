import 'package:flutter/material.dart';
import '../services/dictionary_api_service.dart';
import '../services/storage_service.dart';
import 'word_detail_screen.dart';
import 'quiz_screen.dart';
import 'quiz_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final DictionaryApiService _apiService = DictionaryApiService();
  final StorageService _storageService = StorageService();
  
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _searchWord() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await _apiService.fetchWord(query);
      if (results.isEmpty) {
        setState(() {
          _errorMessage = "Sorry pal, we couldn't find definitions for the word you were looking for.";
        });
      } else {
        if (!mounted) return;
        
        // Save to history for quiz
        final firstWord = results.first;
        if (firstWord.meanings.isNotEmpty && firstWord.meanings.first.definitions.isNotEmpty) {
          await _storageService.addWordToHistory(
            firstWord.word, 
            firstWord.meanings.first.definitions.first.definition
          );
        }

        // Navigate to detail screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WordDetailScreen(wordData: results.first),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred while fetching the data.";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary App'),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    'Vocabulary Learner',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Master your English', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search Dictionary'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.quiz),
              title: const Text('History Quiz'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizScreen(isRandom: false)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.shuffle),
              title: const Text('Random Quiz (跳痛)'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizScreen(isRandom: true)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Quiz History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizHistoryScreen()));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a word...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _searchController.clear(),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _searchWord(),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_errorMessage != null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              )
            else
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu_book_rounded, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Type a word to search for its meaning',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
