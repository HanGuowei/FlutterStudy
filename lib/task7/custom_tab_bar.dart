import 'package:flutter/material.dart';
import 'package:flutter_study/task7/favorites_list_page.dart';
import 'package:flutter_study/task7/news_list_page.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({super.key});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    const children = <Widget>[
       NewsListPage(),
       FavoritesListPage(),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper,),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite,),
            label: 'Favorites',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: children,
      ),
    );
  }
}