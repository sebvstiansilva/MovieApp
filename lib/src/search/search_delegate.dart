import 'package:flutter/material.dart';

import 'package:movies/src/providers/movies_provider.dart';

import 'package:movies/src/models/movie_model.dart';

class MovieSearch extends SearchDelegate {
  
  String selected;
  final movieProvider = new MoviesProvider();

  final movies = [
    'Spiderman',
    'Aquaman',
    'Batman',
    'Shazam',
    'Ironman'
  ];

  final recentlyMovies = [
    'Shazam',
    'Ironman'
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
      // Appbar actions
      return [

        IconButton(
          icon: Icon( Icons.clear ),
          onPressed: () { query = ''; } // Empty string
        ),

      ];
    }
  
  @override
  Widget buildLeading(BuildContext context) {
    // Left icon
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () { close(context, null); } // Close screen search
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Create results to show
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(selected),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Suggestions to show

    if ( query.isEmpty ) {
      return Container();
    }
    
    return FutureBuilder(
      future: movieProvider.searchMovie( query ),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        
        if ( snapshot.hasData ) { 
          final movies = snapshot.data;
          return ListView(
            children: movies.map( (p) {
              return ListTile(
                leading: FadeInImage(
                  placeholder: AssetImage( 'assets/img/no-image.jpg' ),
                  image: NetworkImage( p.getPosterImg() ),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text( p.title ),
                subtitle: Text( p.originalTitle ),
                onTap: () {
                  close( context, null );
                  p.uniqueId = '';
                  Navigator.pushNamed(context, 'detail', arguments: p);
                },
              );
            }).toList(),
          );

        } else {
          return Center(child: CircularProgressIndicator());
        }

      },
    );

  }


  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   // Suggestions to show

  //   final suggestedList = ( query.isEmpty ) 
  //                         ? recentlyMovies
  //                         : movies.where( (m) => m.toLowerCase().startsWith(query.toLowerCase()) ).toList();

  //   return ListView.builder(
  //     itemCount: suggestedList.length,
  //     itemBuilder: ( context, index ) {
  //       return ListTile(
  //         leading: Icon( Icons.movie ),
  //         title: Text( suggestedList[index] ),
  //         onTap: () {
  //           selected = suggestedList[index];
  //           showResults( context );
  //         },
  //       );
  //     },
  //   );
  // }



}