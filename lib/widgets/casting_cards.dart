import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/models/film.dart';
import 'package:peliculas/providers/films_provider.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';


class CastingCards extends StatelessWidget {

  final int filmId;

  const CastingCards(
    {
      super.key, 
      required this.filmId
    }
  );

  @override
  Widget build(BuildContext context) {

    final filmsProvider = Provider.of<FilmsProvider>(context, listen: false);

    return FutureBuilder(
      future: filmsProvider.getMovieCast(filmId),
      builder: (_, AsyncSnapshot<List<Cast>> snapshot) {

        if (!snapshot.hasData){
          return Container(
            constraints: const BoxConstraints(maxWidth: 150),
            height: 180,
            child: const CupertinoActivityIndicator(),
          );
        }

        final List<Cast> cast = snapshot.data!;

        return Container(
          margin: const EdgeInsets.only(bottom: 30),
          width: double.infinity,
          height: 180,
          child: ListView.builder(
            itemCount: cast.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index){
              return _CastCard(actor: cast[index]);
            }
          ),
        );   

      }
    );

  }
}

class _CastCard extends StatelessWidget {

  final Cast actor;

  const _CastCard(
    {
      super.key, 
      required this.actor
    }
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      child: Column(
        children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FadeInImage(
              image: NetworkImage(actor.fullProfilePath),
              placeholder: const AssetImage('assets/img/no-image.jpg'),
              height: 140,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            actor.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
          

        ],
      ),
    );
  }
}