import 'package:flutter/material.dart';

// 1-3. 리스트 화면 (임포트)
import 'model/response/movies_response.dart';
import 'package:padak_starter/detail_page.dart';

class ListPage extends StatelessWidget {
  // final List<Movie> movies = DummysRepository.loadDummyMovies();
  final List<Movie> movies;
  ListPage(this.movies);

  @override
  Widget build(BuildContext context) {
    // 1-3. 리스트 화면 (동적 데이터 추가)

    // 1-3. 리스트 화면 (초기 리스트 구현)
    return ListView.separated(
        itemBuilder: (context, index) => _buildListItem(context, index: index),
        separatorBuilder: (_, index) => Divider(color: Colors.grey),
        itemCount: movies.length);
  }

  // 1-3. 리스트 화면 (고정 더미 데이터)
  Widget _buildListItem(BuildContext context, {@required int index}) {
    Movie movie = movies[index];

    return InkWell(
        child: _buildItem(movie),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => DetailPage(movie.id)));
        });
  }

  // 1-3. 리스트 화면 (동적 데이터 호출1)
  Widget _buildItem(Movie movie) {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.network(movie.thumb, height: 120),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      movie.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    _buildGradeImage(movie.grade),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Text('평점 : ${movie.userRating / 2}'),
                    SizedBox(width: 10),
                    Text('예매순위 : ${movie.reservationGrade}'),
                    SizedBox(width: 10),
                    Text('예매율 : ${movie.reservationRate}')
                  ],
                ),
                SizedBox(height: 10),
                Text('개봉일 : ${movie.date}')
              ],
            ),
          )
        ],
      ),
    );
  }

  // 1-3. 리스트 화면 (관람 등급 이미지 버튼 함수 생성)
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
