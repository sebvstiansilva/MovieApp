import 'package:flutter/material.dart';

import 'package:movies/src/models/movie_model.dart';
import 'package:movies/src/models/actor_model.dart';

import 'package:movies/src/providers/movies_provider.dart';

class MovieDetail extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    final Movie movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _createAppbar( movie ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox( height: 10.0 ),
                _titlePoster( context, movie ),
                _description( movie ),
                _actors( movie )
              ]
            )
          )
        ],
      ),
    );
  }

  Widget _createAppbar(Movie movie) {

    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          movie.title,
          style: TextStyle( color: Colors.white, fontSize: 16.0 ),
        ),
        background: FadeInImage(
          image: NetworkImage( movie.getBackgroundImg() ),
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration(milliseconds: 15),
          fit: BoxFit.cover,
        ),
      ),
    );

  }

  Widget _titlePoster(BuildContext context, Movie movie) {

    return Container(
      padding: EdgeInsets.symmetric( horizontal: 20.0 ),
      child: Row(
        children: [
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular( 20.0 ),
              child: Image(image: NetworkImage( movie.getPosterImg() ), height: 150.0,)
            ),
          ),
          SizedBox( width: 20.0, ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( movie.title, style: Theme.of(context).textTheme.subtitle1, overflow: TextOverflow.ellipsis, ),
                Text( movie.originalTitle, style: Theme.of(context).textTheme.subtitle2, overflow: TextOverflow.ellipsis, ),
                Row(
                  children: [
                    Icon( Icons.star_border ),
                    Text( movie.voteAverage.toString(), style: Theme.of(context).textTheme.bodyText2, )
                  ],
                )
              ],
            )
          )
        ],
      )
    );

  }

  Widget _description(Movie movie) {

    return Container(
      padding: EdgeInsets.symmetric( horizontal: 24.0, vertical: 16.0 ),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
      ),
    );

  }

  Widget _actors(Movie movie) {

    final movieProvider = new MoviesProvider();

    return FutureBuilder(
      future: movieProvider.getCast( movie.id.toString() ),
      builder: ( context, AsyncSnapshot<List> snapshot ) {
        if ( snapshot.hasData ) {
          return _actorsPageView( snapshot.data );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );


  }

  Widget _actorsPageView(List<Actor> actors) {

    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        itemBuilder: ( context, i) => _actorCard( actors[i] ),
        itemCount: actors.length,
        controller: PageController(
          initialPage: 1,
          viewportFraction: 0.3
        ),

      ),
    );

  }

  Widget _actorCard( Actor actor ) {

    return Container(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular( 20.0 ),
            child: FadeInImage(
              placeholder: AssetImage('assets/img/no-image.jpg'),
              image: NetworkImage( actor.getPhoto() ),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          
          Text( actor.name, textAlign: TextAlign.center, )

        ],
      ),
    );

  }

}