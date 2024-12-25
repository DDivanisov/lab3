import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/error_message.dart';
import '../widgets/loading_spinner.dart';
import '../widgets/joke_card.dart';

class JokesByTypeScreen extends StatelessWidget {
  final String type;

  const JokesByTypeScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$type Jokes'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ApiServices.fetchJokesByType(type),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingSpinner();
          } else if (snapshot.hasError) {
            return ErrorMessage(message: "Error: ${snapshot.error}");
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const ErrorMessage(message: "No jokes available for this type.");
          }

          final jokes = snapshot.data!;
          return ListView.builder(
            itemCount: jokes.length,
            itemBuilder: (context, index) {
              final joke = jokes[index];
              return JokeCard(
                setup: joke['setup'],
                punchline: joke['punchline'],
              );
            },
          );
        },
      ),
    );
  }
}
