import 'package:flutter/material.dart';
import 'package:lab3/widgets/joke_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteJokesScreen extends StatefulWidget {
  const FavoriteJokesScreen({super.key});

  @override
  State<FavoriteJokesScreen> createState() => _FavoriteJokesScreenState();
}

class _FavoriteJokesScreenState extends State<FavoriteJokesScreen> {
  List<Map<String, dynamic>> _favoriteJokes = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteJokes();
  }

  Future<void> _loadFavoriteJokes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? favorites = prefs.getString('favorite_jokes'); 
    if (favorites != null) {
      final List<dynamic> favoriteJokes = jsonDecode(favorites);
      if (mounted) {
        setState(() {
          _favoriteJokes = favoriteJokes.cast<Map<String, dynamic>>();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Jokes'),
      ),
      body: _favoriteJokes.isEmpty
          ? const Center(
              child: Text(
                'No favorite jokes found!',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: _favoriteJokes.length,
              itemBuilder: (context, index) {
                final joke = _favoriteJokes[index];
                return JokeCard(
                  setup: joke['setup'],
                  punchline: joke['punchline'],
                );
              },
            ),
    );
  }
}
