// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:newsapp/model/news.dart';
import 'package:newsapp/newsApi/newsApi.dart';
import 'package:newsapp/screens/newsDetailScreen.dart';
import 'package:newsapp/screens/profileScreen.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({Key? key}) : super(key: key);

  @override
  NewsListScreenState createState() => NewsListScreenState();
}

class NewsListScreenState extends State<NewsListScreen> {
  int selectedIndex = 0;
  List<News> articles = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews({bool isLoadMore = false}) async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
      if (!isLoadMore) currentPage = 1;
    });

    try {
      List<News> fetchedArticles =
          await NewsApiClient.fetchArticles(page: currentPage);
      if (fetchedArticles.isEmpty) {
        hasMore = false;
      } else {
        setState(() {
          if (isLoadMore) {
            articles.addAll(fetchedArticles);
          } else {
            articles = fetchedArticles;
          }
          currentPage++;
        });
      }
      // ignore: empty_catches
    } catch (error) {
    } finally {
      setState(() => isLoading = false);
    }
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            Text(selectedIndex == 0 ? 'news_title'.tr() : 'profile_title'.tr()),
      ),
      body: selectedIndex == 0 ? buildNewsGrid() : const ProfileScreen(),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildNewsGrid() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: articles.length + (hasMore ? 1 : 0),
        itemBuilder: (BuildContext context, int index) {
          if (index >= articles.length) {
            return Center(
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.green,
                      )
                    : null);
          }
          return buildArticleCard(articles[index]);
        },
      ),
    );
  }

  Widget buildArticleCard(News article) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => NewsDetailScreen(article: article)));
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Image.network(
                article.urlToImage,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset('assets/noPhoto.png', fit: BoxFit.cover),
              ),
            ),
            ListTile(
              title: Text(article.title,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(article.description,
                  maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: const Icon(Icons.newspaper), label: 'news_tapbar'.tr()),
        BottomNavigationBarItem(
            icon: const Icon(Icons.person), label: 'profile_tapbar'.tr()),
      ],
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.green,
      currentIndex: selectedIndex,
      onTap: onItemTapped,
    );
  }
}
