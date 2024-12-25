import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/error_message.dart';
import '../widgets/loading_spinner.dart';
import '../widgets/joke_card.dart';

class RandomJokeScreen extends StatelessWidget {
 const RandomJokeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Joke'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: ApiServices.fetchRandomJoke(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingSpinner();
          } else if (snapshot.hasError) {
            return ErrorMessage(message: "Error: ${snapshot.error}");
          } else if (!snapshot.hasData) {
            return const ErrorMessage(message: "No random joke available.");
          }
          final joke = snapshot.data!;
          return JokeCard(
            setup: joke['setup'],
            punchline: joke['punchline'],
          );
        },
      ),
    );
  }
}
