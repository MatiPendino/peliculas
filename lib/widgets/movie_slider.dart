import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';


class MovieSlider extends StatefulWidget {

  final List<Film> popularFilms;
  final String? title;
  final Function onNextPage;

  const MovieSlider({
    super.key, 
    required this.popularFilms,
    required this.onNextPage,
    this.title
  });

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 300){
        widget.onNextPage();
      }
    });
  }

  @override
  void dispose() {
    
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(widget.title!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),

          const SizedBox(height: 5),

          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.popularFilms.length,
              //itemCount: 10,
              itemBuilder: (BuildContext _, int index){
                final Film film = widget.popularFilms[index];

                //return _MoviePoster();
                return _MoviePoster(film: film, heroId: '${widget.title}-$index-${film.id}');
              }
            ),
          )
          

        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {

  final Film film;
  final String heroId;

  const _MoviePoster(
    {
      super.key, 
      required this.film, 
      required this.heroId
    }
  );


  @override
  Widget build(BuildContext context) {
    film.heroId = heroId;

    return Container(
      width: 130, 
      height: 190, 
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
      
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, 'details', arguments: film),
              child: Hero(
                tag: film.heroId!,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FadeInImage(
                    placeholder: const AssetImage('assets/img/no-image.jpg'), 
                    image: NetworkImage(film.fullPosterImg),
                    //image: AssetImage('assets/img/no-image.jpg'),
                    width: 130,
                    height: 190,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
      
            const SizedBox(height: 5),
      
            Text(
              //"título",
              film.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            )
      
          ],
        ),
      ),
    );
  }
}