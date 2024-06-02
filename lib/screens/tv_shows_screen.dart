import 'package:flutter/material.dart';
import 'package:movies_app/tv_show_screens/airing_today_tv_shows.dart';
import 'package:movies_app/tv_show_screens/on_the_air_tv_shows.dart';

import '../tv_show_screens/popular_tv_shows.dart';
import '../tv_show_screens/top_rated_tv_shows.dart';

class TvShowsScreen extends StatefulWidget {
  const TvShowsScreen({super.key});

  @override
  State<TvShowsScreen> createState() => _TvShowsScreenState();
}

class _TvShowsScreenState extends State<TvShowsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tv Shows'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 380,
              child: AiringTodayTvShows(),
            ),
            Container(
              height: 380,
              child: OnTheAirTvShows(),
            ),
            Container(
              height: 380,
              child: PopularTvShows(),
            ),
            Container(
              height: 380,
              child: TopRatedTvShows(),
            ),
          ],
        ),
      ),
    );
  }
}
