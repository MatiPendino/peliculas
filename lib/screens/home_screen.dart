import 'package:flutter/material.dart';
import 'package:peliculas/providers/films_provider.dart';
import 'package:peliculas/search/search_delegate.dart';
import 'package:peliculas/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
   
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final filmsProvider = Provider.of<FilmsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas en cines'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => showSearch(
              context: context, 
              delegate: FilmSearchDelegate()
            ),
            icon: const Icon(Icons.search_outlined)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // Tarjetas principales
            CardSwiper(films: filmsProvider.onDisplayFilms),
            //CardSwiper(),

            // Slider de películas
            MovieSlider(
              popularFilms: filmsProvider.popularFilms, 
              title: "Últimas",
              onNextPage: () => filmsProvider.getPopularFilms()
            )
            //MovieSlider()

            
          ],
      ),
      )
    );
  }
}