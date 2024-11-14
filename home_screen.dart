import 'package:app/detail.dart';
import 'package:app/movie.dart';
import 'package:app/search.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> _movies;

  @override
  void initState() {
    super.initState();
    _movies = fetchMovies();
  }

  // Fetch movies from the API
  Future<List<Movie>> fetchMovies() async {
    final response =
        await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=all'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: GestureDetector(
          onTap: () {
            // Redirect to Search Screen when tapped
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (ctx) => SearchScreen()));
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Search Movies...',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Movie>>(
        future: _movies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No movies found.'));
          } else {
            final movies = snapshot.data!;
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to Details Screen and pass the movie data
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => DetailsScreen(movie)));
                  },
                  child: Card(
                    margin: EdgeInsets.all(8.0),
                    color: Colors.grey[900],
                    child: Row(
                      children: [
                        // Movie Thumbnail with adjusted size and border radius
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            movie.imageUrl,
                            width: 100,
                            height: 150,
                            fit: BoxFit
                                .cover, // Ensures the image fills the space while maintaining aspect ratio
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 100,
                                height: 150,
                                color: Colors.grey[800],
                                child: Icon(Icons.error, color: Colors.white),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        // Movie Details
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  movie.summary,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}
