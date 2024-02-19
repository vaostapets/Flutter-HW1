class News {
  final String title;
  final String description;
  final String urlToImage;
  final String content;
  final String url;
  final String publishedAt;
  final String author;

  News({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.content,
    required this.url,
    required this.publishedAt,
    required this.author,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'] as String? ?? 'No Title',
      description: json['description'] as String? ?? 'No Description',
      urlToImage:
          json['urlToImage'] as String? ?? 'https://via.placeholder.com/150',
      content: json['content'] as String? ?? 'No Content',
      url: json['url'] as String? ?? 'No URL',
      publishedAt: json['publishedAt'] as String? ?? 'No Publication Date',
      author: json['author'] as String? ?? 'Unknown Author',
    );
  }
}
