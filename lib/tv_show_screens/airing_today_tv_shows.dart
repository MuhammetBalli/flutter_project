import 'package:flutter/material.dart';
import 'package:movies_app/providers/tv_show_provider.dart';
import 'package:movies_app/screens/tv_show_details.dart';
import 'package:provider/provider.dart';

class AiringTodayTvShows extends StatefulWidget {
  const AiringTodayTvShows({Key? key}) : super(key: key);

  @override
  _AiringTodayTvShowsState createState() => _AiringTodayTvShowsState();
}

class _AiringTodayTvShowsState extends State<AiringTodayTvShows> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final tvShowProvider = Provider.of<TvShowProvider>(context, listen: false);
    tvShowProvider.fetchAiringTodayTvShows();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final tvShowProvider = Provider.of<TvShowProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !tvShowProvider.isAiringTodayTvShowLoading) {
      tvShowProvider.fetchAiringTodayTvShows();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TvShowProvider>(
        builder: (context, tvShowProvider, child) {
          if (tvShowProvider.isAiringTodayTvShowLoading &&
              tvShowProvider.tvShowsAiringToday.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (tvShowProvider.tvShowsAiringToday.isEmpty) {
            return const Center(child: Text('No TV shows available'));
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Airing Today'),
                      Text('See all'),
                    ],
                  ),
                ),
                Container(
                  height: 330,
                  color: Colors.red,
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: tvShowProvider.tvShowsAiringToday.length +
                        (tvShowProvider.isAiringTodayTvShowLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == tvShowProvider.tvShowsAiringToday.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final tvShow = tvShowProvider.tvShowsAiringToday[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TvShowDetails(tvShow: tvShow),
                            ),
                          );
                        },
                        child: Container(
                          width: 160,
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 150,
                                    height: 225,
                                    color: Colors.grey,
                                    child: tvShow.poster.isEmpty
                                        ? Image.asset('assets/no_image.jpg', fit: BoxFit.cover)
                                        : const Center(child: CircularProgressIndicator()),
                                  ),
                                  if (tvShow.poster.isNotEmpty)
                                    Image.network(
                                      'https://image.tmdb.org/t/p/w500${tvShow.poster}',
                                      fit: BoxFit.cover,
                                      width: 150,
                                      height: 225,
                                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Container(
                                          width: 150,
                                          height: 225,
                                          color: Colors.grey,
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                tvShow.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(tvShow.rating.toStringAsFixed(1)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}


