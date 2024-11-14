import 'package:app/detail.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/movie.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _searchResults = [];
  bool _isLoading = false;

  // Function to search for movies using the API
  Future<void> searchMovies(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final response = await http
        .get(Uri.parse('https://api.tvmaze.com/search/shows?q=$query'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _searchResults = data.map((json) => Movie.fromJson(json)).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to search movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          controller: _searchController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search Movies...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                searchMovies(_searchController.text);
              },
            ),
          ),
          onSubmitted: (query) => searchMovies(query),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
              ? Center(
                  child: Text('No movies found.',
                      style: TextStyle(color: Colors.white)))
              : ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final movie = _searchResults[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to Details Screen and pass the movie data
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => DetailsScreen(movie),
                          ),
                        );
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
                                    child:
                                        Icon(Icons.error, color: Colors.white),
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
                ),
      backgroundColor: Colors.black,
    );
  }
}
