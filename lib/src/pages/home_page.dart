import 'package:flutter/material.dart';

import 'package:movies/src/widgets/card_swiper_widget.dart';
import 'package:movies/src/widgets/movie_horizontal.dart';

import 'package:movies/src/providers/movies_provider.dart';

import 'package:movies/src/search/search_delegate.dart';

class HomePage extends StatelessWidget {

  final moviesProvider = new MoviesProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
            Icon(Icons.movie),
            SizedBox(width: 10.0,),
            Text('Movies API')
          ],
        ),
        backgroundColor: Colors.indigoAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white,),
            onPressed: () {
              showSearch( context: context, delegate: MovieSearch() );
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _swiperCard(),
            _footer( context )
          ],
        ), 
      ),
    );
  }

  Widget _swiperCard() {

    return FutureBuilder(
      future: moviesProvider.getNowPlaying(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        
        if ( snapshot.hasData ) {
          return CardSwiper( movies: snapshot.data );
        } else {
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator()
            )
          );
        }

        
      
      },
    );
    
    
  }

  Widget _footer( BuildContext context ) {

    moviesProvider.getPopular();

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only( left: 24.0 ),
            child: Text( 'Populares', style: Theme.of(context).textTheme.headline4 )
          ),
          SizedBox( height: 5.0, ),
          StreamBuilder(
            stream: moviesProvider.popularsStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              
              if ( snapshot.hasData ) {
                return MovieHorizontal( movies: snapshot.data, nextPage: moviesProvider.getPopular, );
              } else { 
                return Center(child: CircularProgressIndicator());
              }

            },
          ),
        ],
      ),


    );

  }

}