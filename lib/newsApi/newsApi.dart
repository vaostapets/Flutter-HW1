// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newsapp/model/news.dart';

class NewsApiClient {
  static const String apiKey = '7ef39a303b894f70ae2a748b15df7154';
  static const String baseUrl = 'https://newsapi.org/v2';
  static const String headlinesEndpoint =
      '/top-headlines?country=us&apiKey=$apiKey';

  static Future<List<News>> fetchArticles({int page = 1}) async {
    final String url = '$baseUrl$headlinesEndpoint&page=$page';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result['articles'];
      return list.map((article) => News.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
