import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';

class CardSwiper extends StatelessWidget {

  final List<Film> films;
   
  const CardSwiper({
    Key? key, 
    required this.films
    }
  ) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    if (films.isEmpty){
      return Container(
        width: double.infinity,
        height: size.height/2,
        child: const Center(
          child: CircularProgressIndicator()
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: size.height/2,
      child: Swiper(
        itemCount: films.length,
        //itemCount: 10,
        layout: SwiperLayout.STACK,
        itemWidth: size.width*0.6,
        itemHeight: size.height*0.4,
        itemBuilder: (_, index) {

          final film = films[index];

          film.heroId = 'swiper-${film.id}';
          
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details', arguments: film),
            child: Hero(
              tag: film.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  image: NetworkImage(film.fullPosterImg),
                  //image: AssetImage('assets/img/no-image.jpg'),
                  placeholder: const AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}