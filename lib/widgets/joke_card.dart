import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class JokeCard extends StatefulWidget {
  final String setup;
  final String punchline;

  const JokeCard({
    super.key,
    required this.setup,
    required this.punchline,
  });

  @override
  State<JokeCard> createState() => _JokeCardState();
}

class _JokeCardState extends State<JokeCard> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? favorites = prefs.getString('favorite_jokes');
    if (favorites != null) {
      final List<dynamic> favoriteJokes = jsonDecode(favorites);
      if (mounted) {
        setState(() {
          _isFavorite = favoriteJokes.any((j) =>
              j['setup'] == widget.setup && j['punchline'] == widget.punchline);
        });
      }
    }
  }

  Future<void> _toggleFavorite() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the existing list of favorite jokes
    final String? favorites = prefs.getString('favorite_jokes');
    List<dynamic> favoriteJokes = favorites != null ? jsonDecode(favorites) : [];

    // Check if the joke is already saved
    final Map<String, String> joke = {'setup': widget.setup, 'punchline': widget.punchline};
    if (_isFavorite) {
      // Remove from favorites
      favoriteJokes.removeWhere((j) =>
          j['setup'] == widget.setup && j['punchline'] == widget.punchline);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Joke removed from favorites!')),
        );
      }
    } else {
      // Add to favorites
      favoriteJokes.add(joke);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Joke added to favorites!')),
        );
      }
    }

    // Save the updated list
    await prefs.setString('favorite_jokes', jsonEncode(favoriteJokes));

    // Update UI
    if (mounted) {
      setState(() {
        _isFavorite = !_isFavorite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.setup,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.punchline,
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
            IconButton(
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: _toggleFavorite,
            ),
          ],
        ),
      ),
    );
  }
}
