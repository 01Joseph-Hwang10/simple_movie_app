import "package:flutter/material.dart";
import 'package:padak_starter/comment_page.dart';
import 'package:padak_starter/model/data/dummys_repository.dart';
import 'package:padak_starter/model/widget/star_rating_bar.dart';

import 'model/response/comments_response.dart';
import 'model/response/movie_response.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailPage extends StatefulWidget {
  final String movieId;

  DetailPage(this.movieId);

  @override
  State<StatefulWidget> createState() {
    return _DetailState(movieId);
  }
}

class _DetailState extends State<DetailPage> {
  String movieId;
  String _movieTitle;
  CommentsResponse _commentsResponse;
  MovieResponse _movieResponse;

  _DetailState(String movieId) {
    this.movieId = movieId;
  }

  @override
  void initState() {
    super.initState();
    _requestMovie();
  }

  Future<MovieResponse> _getMovieResponse() async {
    final response = await http
        .get('http://padakpadak.run.goorm.io/movie?id=${widget.movieId}');
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final movieResponse = MovieResponse.fromJson(jsonData);
      return movieResponse;
    }
    return null;
  }

  Future<CommentsResponse> _getCommentsResponse() async {
    final response = await http.get(
        'http://padakpadak.run.goorm.io/comments?movie_id=${widget.movieId}');
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final commentsResponse = CommentsResponse.fromJson(jsonData);
      return commentsResponse;
    }
    return null;
  }

  void _requestMovie() async {
    setState(() {
      _movieResponse = null;
    });
    final movieResponse = await _getMovieResponse();
    final commentsResponse = await _getCommentsResponse();

    setState(() {
      _movieResponse = movieResponse;
      _commentsResponse = commentsResponse;
      _movieTitle = movieResponse.title;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 2-1. ?????? ?????? (????????? ????????? ?????? - ?????? ??????)
    _movieResponse = DummysRepository.loadDummyMovie(movieId);
    _commentsResponse = DummysRepository.loadComments(movieId);

    // 2-5. ?????? ?????? (????????? ????????? ?????? - ?????? ??????)

    return Scaffold(
        appBar: AppBar(
          // 2-1. ?????? ?????? (?????? ??????)
          title: Text(_movieTitle),
        ),
        // 2-1. ?????? ?????? (?????? ?????? ??????1)
        body: _buildContents());
  }

  Widget _buildContents() {
    Widget contentsWidget;

    if (_movieResponse == null) {
      contentsWidget = Center(
        child: CircularProgressIndicator(),
      );
    } else {
      contentsWidget = SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            _buildMovieSummary(),
            _buildMovieSynopsis(),
            _buildMovieCast(),
            _buildComment(),
          ],
        ),
      );
    }

    return contentsWidget;
  }

  // 2-1. ?????? ?????? (?????? ?????? ??????2)

  Widget _buildMovieSummary() {
    // 2-2. Summary ?????? (?????? ??????)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.network(
              _movieResponse.image,
              height: 180,
            ),
            SizedBox(
              width: 10,
            ),
            _buildMovieSummaryTextColumn(),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildReservationRate(),
            _buildVerticalDivider(),
            _buildUserRating(),
            _buildVerticalDivider(),
            _buildAudience(),
          ],
        )
      ],
    );
  }

  // 2-2. Summary ?????? (1-2 ??????)
  Widget _buildMovieSummaryTextColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _movieResponse.title,
          style: TextStyle(fontSize: 22),
        ),
        Text(
          '${_movieResponse.date} ??????',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          '${_movieResponse.genre} / ${_movieResponse.duration}???',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  // 2-2. Summary ?????? (2-2 ?????? - ?????????)
  Widget _buildReservationRate() {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              '?????????',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '${_movieResponse.reservationGrade}??? ${_movieResponse.reservationRate.toString()}%',
            )
          ],
        )
      ],
    );
  }

  // 2-2. Summary ?????? (2-2 ?????? - ??????)
  Widget _buildUserRating() {
    return Column(
      children: [
        Text(
          '??????',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text("${_movieResponse.userRating / 2}")
      ],
    );
  }

  // 2-2. Summary ?????? (2-2 ?????? - ???????????????)
  Widget _buildAudience() {
    final numberFormatter = NumberFormat.decimalPattern();
    return Column(
      children: [
        Text(
          '???????????????',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(numberFormatter.format(_movieResponse.audience))
      ],
    );
  }

  // 2-2. Summary ?????? (2-2 ?????? - ?????????)
  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 50,
      color: Colors.grey,
    );
  }

  Widget _buildMovieSynopsis() {
    // 2-3. Synopsis ?????? (?????? ??????)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          height: 10,
          color: Colors.grey.shade400,
        ),
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            '?????????',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 16, top: 10, bottom: 5),
          child: Text(_movieResponse.synopsis),
        )
      ],
    );
  }

  Widget _buildMovieCast() {
    // 2-4. MovieCast ?????? (?????? / ?????? ??????)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          height: 10,
          color: Colors.grey.shade400,
        ),
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            '??????/??????',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 16, top: 10, bottom: 5),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    '??????',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(_movieResponse.director)
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    '??????',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(child: Text(_movieResponse.actor))
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildComment() {
    // 2-5. Comment ?????? (?????? ??????)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          height: 10,
          color: Colors.grey.shade400,
        ),
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '?????????',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.create),
                onPressed: () => _presentCommentPage(context),
                color: Colors.blue,
              )
            ],
          ),
        ),
        _buildCommentListView()
      ],
    );
  }

  // 2-5. Comment ?????? (????????? ?????????)
  Widget _buildCommentListView() {
    return ListView.builder(
        shrinkWrap: true,
        primary: false,
        padding: EdgeInsets.all(10.0),
        itemCount: _commentsResponse.comments.length,
        itemBuilder: (_, index) =>
            _buildItem(comment: _commentsResponse.comments[index]));
  }

  // 2-5. Comment ?????? (????????? ????????? ?????? ??????)
  Widget _buildItem({@required Comment comment}) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.person_pin,
            size: 50,
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(comment.writer),
                  SizedBox(
                    width: 5,
                  )
                ],
              ),
              Text(_convertTimeStampToDateTime(comment.timestamp)),
              SizedBox(
                height: 5,
              ),
              Container(
                width: 165,
                child: Text(comment.contents),
              )
            ],
          ),
          SizedBox(
            width: 5,
          ),
          StarRatingBar(
            rating: comment.rating.toInt(),
            isUserInteractionEnabled: false,
            size: 20,
          )
        ],
      ),
    );
  }

  // 2-5. Comment ?????? (????????? ?????? ?????? ????????? ??????)'
  String _convertTimeStampToDateTime(int timestamp) {
    final dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return dateFormatter
        .format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000));
  }

  // 2-5. Comment ?????? (?????? ?????? ????????? ??????)
  void _presentCommentPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            CommentPage(_movieResponse.title, _movieResponse.id)));
  }
}
