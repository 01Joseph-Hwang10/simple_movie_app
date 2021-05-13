import 'package:flutter/material.dart';
import 'package:padak_starter/detail_page.dart';
import 'model/response/movies_response.dart';
import 'model/data/dummys_repository.dart';

// 1-3. Grid 리스트 화면 (임포트)

class GridPage extends StatelessWidget {
  // 1-4. Grid 리스트 화면 (동적 데이터 추가)
  final List<Movie> movies = DummysRepository.loadDummyMovies();

  @override
  Widget build(BuildContext context) {
    // 1-4. Grid 리스트 화면 (GridView 구축)
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: (9 / 16)),
      itemBuilder: (context, index) => _buildGridItem(context, index: index),
      itemCount: movies.length,
      scrollDirection: Axis.vertical,
    );
  }

  // 1-4. Grid 리스트 화면 (Grid 아이템 화면 구축)
  Widget _buildGridItem(BuildContext context, {@required int index}) {
    Movie movie = movies[index];

    return InkWell(
        child: _buildItem(movie),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => DetailPage(movie.id)));
        });
  }

  Widget _buildItem(Movie movie) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Expanded(
              child: Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              Image.network(movie.thumb,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity),
              Container(
                padding: EdgeInsets.all(8),
                child: _buildGradeImage(movie.grade),
              )
            ],
          )),
          SizedBox(
            height: 8,
          ),
          FittedBox(
            child: Text(
              movie.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
              '${movie.reservationGrade}위(${movie.userRating}) / ${movie.reservationRate}%'),
          SizedBox(
            height: 8,
          ),
          Text('${movie.date}'),
        ],
      ),
    );
  }

  // 1-4. Grid 리스트 화면 (관람 등급 이미지 버튼 함수 생성)
  Widget _buildGradeImage(int grade) {
    switch (grade) {
      case 0:
        return Image.asset('assets/ic_allages.png');
      case 12:
        return Image.asset('assets/ic_12.png');
      case 15:
        return Image.asset('assets/ic_15.png');
      case 19:
        return Image.asset('assets/ic_19.png');
      default:
        return null;
    }
  }
}
