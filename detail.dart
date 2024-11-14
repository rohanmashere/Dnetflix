// detail.dart
import 'package:flutter/material.dart';
import 'movie.dart'; // Import your Movie model

class DetailsScreen extends StatelessWidget {
  final Movie movie;

  // Constructor to receive the movie data
  DetailsScreen(this.movie);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Movie Image
              Center(
                child: Image.network(
                  movie.imageUrl,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              // Movie Title
              Text(
                movie.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              // Movie Summary
              Text(
                'Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5),
              Text(
                movie.summary
                    .replaceAll(RegExp(r'<[^>]*>'), ''), // Remove HTML tags
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              SizedBox(height: 20),
              // Additional Details
              Text(
                'Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Language: ${movie.language}',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              SizedBox(height: 5),
              Text(
                'Genres: ${movie.genres}',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              SizedBox(height: 5),
              Text(
                'Rating: ${movie.rating ?? 'N/A'}',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              SizedBox(height: 5),
              Text(
                'Premiered: ${movie.premieredDate ?? 'N/A'}',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
