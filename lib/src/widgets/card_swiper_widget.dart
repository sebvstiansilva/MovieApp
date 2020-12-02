import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:movies/src/models/movie_model.dart';

class CardSwiper extends StatelessWidget {
  
  final List<Movie> movies;
  
  const CardSwiper({Key key, @required this.movies}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size; // Width & height for each phone.

    return Container(
      padding: EdgeInsets.only( top: 18.0 ),
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) {

          movies[index].uniqueId = '${ movies[index].id }-card';

          return Hero(
            tag: movies[index].uniqueId,
            child: GestureDetector(
              onTap: () => Navigator.pushNamed( context, 'detail', arguments: movies[index] ),
              child: FadeInImage(
                image: NetworkImage( movies[index].getPosterImg() ),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        itemCount: movies.length,
        // pagination: SwiperPagination(),
        // control: SwiperControl(),
      ),
    );
  }
}