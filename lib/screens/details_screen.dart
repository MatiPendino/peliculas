import 'package:flutter/material.dart';
import 'package:peliculas/widgets/widgets.dart';

import '../models/models.dart';


class DetailsScreen extends StatelessWidget {
   
  const DetailsScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final Film film = ModalRoute.of(context)!.settings.arguments as Film;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(film: film),
          SliverList(
            delegate: SliverChildListDelegate([
              _PosterAndTitle(film: film),
              _Overview(film: film),
              CastingCards(filmId: film.id),
            ])
          )
        ],
      )
    );
  }
}

class _CustomAppBar extends StatelessWidget {

  final Film film;

  const _CustomAppBar(
    {
      super.key, 
      required this.film
    }
  );

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          color: Colors.black12,
          child: (
            Text(
              film.title,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            )
          )
        ),
        background: FadeInImage(
          placeholder: const AssetImage('assets/img/loading.gif'), 
          image: NetworkImage(film.fullBackdropPath),
          fit: BoxFit.contain,
        ),
      ),

    );
  }
}

class _PosterAndTitle extends StatelessWidget {

  final Film film;

  const _PosterAndTitle(
    {
      super.key, 
      required this.film
    }
  );

  @override
  Widget build(BuildContext context) {

    final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: film.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                image: NetworkImage(film.fullPosterImg),
                placeholder: const AssetImage('assets/img/no-image.jpg'),
                height: 150,
              ),
            ),
          ),

          const SizedBox(width: 20),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [   

              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: size.width - 165),
                child: Text(
                  film.title, 
                  style: textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),

              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: size.width - 165),
                child: Text(
                  film.originalTitle, 
                  style: textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              Row(
                children: [
                  const Icon(Icons.start_outlined, size: 15, color: Colors.grey,),

                  const SizedBox(width: 5),

                  Text(film.voteAverage.toString(), style: textTheme.caption,)
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {

  final Film film;

  const _Overview(
    {
      super.key,
      required this.film
    }
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Text(
        film.overview,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}