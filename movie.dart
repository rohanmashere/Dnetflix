// movie.dart
class Movie {
  final String title;
  final String imageUrl;
  final String summary;
  final String language;
  final String genres;
  final double? rating;
  final String? premieredDate;

  Movie({
    required this.title,
    required this.imageUrl,
    required this.summary,
    required this.language,
    required this.genres,
    this.rating,
    this.premieredDate,
  });

  // Create a Movie object from JSON
  factory Movie.fromJson(Map<String, dynamic> json) {
    final show = json['show'];
    return Movie(
      title: show['name'] ?? 'No Title',
      imageUrl: show['image'] != null ? show['image']['medium'] : '',
      summary: show['summary'] ?? 'No Summary Available',
      language: show['language'] ?? 'Unknown',
      genres: (show['genres'] as List<dynamic>).join(', '),
      rating: show['rating']['average'] != null
          ? (show['rating']['average'] as num).toDouble()
          : null,
      premieredDate: show['premiered'] ?? 'Unknown',
    );
  }
}
