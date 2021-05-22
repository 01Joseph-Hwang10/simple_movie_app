import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import 'package:padak_starter/model/response/movies_response.dart';
import 'dart:convert';

// 1-2. 탭 화면 (각 화면 import)
import 'grid_page.dart';
import 'list_page.dart';

// 1-2. 탭 화면 (Stateless -> Stateful)
class MainPage extends StatefulWidget {
  // 1-2. 탭 화면 (createState 함수 추가)
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

// 1-2. 탭 화면 (build() 함수를 _MainState로 옮김)
class _MainPageState extends State<MainPage> {
  MoviesResponse _moviesResponse;

  // 1-2. 탭 화면 (_selectedTabIndex 변수 옮김)
  // 1-2. 탭 화면 (탭 인덱스 설정)
  int _selectedTabIndex = 0;

  int _selectedSortIndex = 0;

  void _requestMovies() async {
    setState(() {
      _moviesResponse = null;
    });

    final response = await http.get(
        'http://padakpadak.run.groom.io/movies?order_type=$_selectedSortIndex');
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final moviesResponse = MoviesResponse.fromJson(jsonData);
      setState(() {
        _moviesResponse = moviesResponse;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _requestMovies();
  }

  String _getMenuTitleBySortIndex(int index) {
    switch (index) {
      case 0:
        return '예매율';
      case 1:
        return '큐레이션';
      case 2:
        return '최신순';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 1-1. 상단화면 (제목 수정)
        title: Text(_getMenuTitleBySortIndex(_selectedSortIndex)),
        // 1-1. 상단화면 (좌측 버튼 추가)
        // leading: Icon(Icons.menu),
        // 1-1. 상단화면 (우측 팝업 버튼 및 이벤트 추가)
        actions: <Widget>[_buildPopupMenuButton(context)],
      ),
      // 1-2. 탭 화면 (List, Grid Widget 연동)
      body: _buildPage(_selectedTabIndex, _moviesResponse),
      // 1-2. 탭 화면 (bottomNavigationBar 추가)
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.view_list), label: 'List'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_on), label: 'Grid'),
        ],
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
            print("$_selectedTabIndex Tab Clicked");
          });
        },
      ),
    );
  }

  void _onSortMethodTap(index) {
    setState(() {
      _selectedSortIndex = index;
    });
    _requestMovies();
  }

  Widget _buildPopupMenuButton(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(Icons.sort),
      onSelected: _onSortMethodTap,
      itemBuilder: (context) {
        return [
          PopupMenuItem(value: 0, child: Text("예매율순")),
          PopupMenuItem(value: 1, child: Text("큐레이션")),
          PopupMenuItem(value: 2, child: Text("최신순")),
        ];
      },
    );
  }
}

// 1-2. 탭 화면 (State 구현)

// 1-2. 탭 화면 (List, Grid Widget 반환)
Widget _buildPage(index, moviesResponse) {
  Widget contentsWidget;

  if (moviesResponse == null)
    contentsWidget = Center(
      child: CircularProgressIndicator(),
    );
  else
    switch (index) {
      case 0:
        contentsWidget = ListPage(moviesResponse.movies);
        break;
      case 1:
        contentsWidget = GridPage(moviesResponse.movies);
        break;
      default:
        contentsWidget = Container();
    }

  return contentsWidget;
}
