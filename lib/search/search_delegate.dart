
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:peliculas/providers/films_provider.dart';

import '../models/models.dart';

class FilmSearchDelegate extends SearchDelegate{

  @override
  // TODO: implement searchFieldLabel
  String? get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }

  Widget _emptyContainer(){
    return Container(
      child: const Center(
        child: Icon(Icons.movie_creation_outlined, color: Colors.black38, size: 100),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    
    if(query.isEmpty){
      return _emptyContainer();
    }

    final filmsProvider = Provider.of<FilmsProvider>(context, listen: false);
    filmsProvider.getSuggestionsByQuery(query);

    return StreamBuilder(
      stream: filmsProvider.suggestionStream,
      builder: (BuildContext _, AsyncSnapshot<List<Film>> snapshot) {

        if (!snapshot.hasData) return _emptyContainer();

        final films = snapshot.data!;

        return ListView.builder(
          itemCount: films.length,
          itemBuilder: (BuildContext _, int index){
            return _filmItem(film: films[index]);
          }
        );
      }
    );

  }

}

class _filmItem extends StatelessWidget {

  final Film film;

  const _filmItem(
    {
      super.key, 
      required this.film
    }
  );

  @override
  Widget build(BuildContext context) {
    film.heroId = 'search-${film.id}';

    return ListTile(
      leading: Hero(
        tag: film.heroId!,
        child: FadeInImage(
          placeholder: const AssetImage('assets/img/no-image.jpg'),
          image: NetworkImage(film.fullPosterImg),
          width: 50,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(film.title),
      subtitle: Text(film.originalTitle),
      onTap: () {
        Navigator.pushNamed(context, 'details', arguments: film);
      },
    );
  }
}