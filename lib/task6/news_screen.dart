import 'package:flutter/material.dart';
import 'package:flutter_study/task6/api/category.dart';
import 'package:flutter_study/task6/api/news_api.dart';
import 'package:flutter_study/task6/article.dart';
import 'package:flutter_study/task6/component/category_selector.dart';
import 'package:flutter_study/task6/component/filter_bar.dart';
import 'package:flutter_study/task6/entity/article_info.dart';
import 'package:flutter_study/task6/news_detail_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsApi _newsApi = NewsApi();
  int _currentPage = 1;
  bool _isMoreLoading = false;
  bool _isMaxResult = false;
  final List<ArticleInfo> _articles = [];
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Category? _category;

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_scrollListener)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Headline'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            child: CategorySelector(
              value: _category,
              onChanged: (category) {
                setState(() {
                  _category = category;
                });
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          FilterBar(
            searchController: _searchController,
            onSearch: _search,
          ),
          Expanded(
            child: _newsListBuild(context),
          )
        ],
      ),
    );
  }

  Widget _newsListBuild(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _search,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        controller: _scrollController,
        itemCount: _articles.length + 1,
        itemBuilder: (context, index) {
          if (index < _articles.length) {
            return Article(
              onTap: () {
                _navigationToDetail(_articles[index]);
              },
              articlesBean: _articles[index],
            );
          }
          if (_isMaxResult) {
            return const Text('No more articles');
          }
          if (_isMoreLoading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: CircularProgressIndicator(),
              ),
            );
          }
          return null;
        },
      ),
    );
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // 滚动到列表底部触发加载更多
      if (!_isMoreLoading) {
        setState(() {
          _isMoreLoading = true;
        });
        _loadMoreNews();
      }
    }
  }

  Future<void> _loadMoreNews() async {
    try {
      final news = await _newsApi.topHeadlines(
        _searchController.text,
        _category,
        _currentPage,
        20,
      );
      _currentPage++;
      setState(() {
        _articles.addAll(news.articles);
        _isMoreLoading = false;
      });
    } on Exception catch (_) {
      setState(() {
        _isMoreLoading = false;
        _isMaxResult = true;
      });
    }
  }

  Future<void> _search() {
    setState(() {
      _currentPage = 1;
      _articles.clear();
      _isMoreLoading = true;
      _isMaxResult = false;
    });
    _loadMoreNews();
    return Future(() => null);
  }

  void _navigationToDetail(ArticleInfo article) {
    Navigator.of(context).push(
      MaterialPageRoute<NewsDetailScreen>(
        builder: (context) => NewsDetailScreen(
          article: article,
        ),
      ),
    );
  }
}
