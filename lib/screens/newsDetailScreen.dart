// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:newsapp/model/news.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class NewsDetailScreen extends StatelessWidget {
  final News article;

  const NewsDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm')
        .format(DateTime.parse(article.publishedAt));

    return Scaffold(
      appBar: AppBar(
        title: Text(article.title, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[800],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(8.0),
              elevation: 5,
              child: Column(
                children: [
                  Image.network(article.urlToImage, fit: BoxFit.cover),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      article.content,
                      style: const TextStyle(fontSize: 18, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${'published_by'.tr()} ${article.author}',
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${'published_time'.tr()}: $formattedDate',
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.open_in_browser, color: Colors.white),
              label: Text('news_browser'.tr(),
                  style: const TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800],
                foregroundColor: Colors.green[200],
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 12.0),
              ),
              onPressed: () async {
                final url = Uri.parse(article.url);
                final scaffoldMessenger = ScaffoldMessenger.of(context);

                if (await canLaunchUrl(url)) {
                  try {
                    await launchUrl(url);
                  } catch (err) {
                    scaffoldMessenger.showSnackBar(const SnackBar(
                        content: Text('Failed to open the article.')));
                  }
                } else {
                  scaffoldMessenger.showSnackBar(SnackBar(
                      content: Text('Could not launch ${article.url}')));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
