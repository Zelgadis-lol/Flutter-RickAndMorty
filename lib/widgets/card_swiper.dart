import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/models.dart';

class CardSwiper extends StatelessWidget {
  final List<Episode> episodes;

  const CardSwiper({Key? key, required this.episodes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (episodes.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: size.height * 0.5,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: size.height * 0.5,
      child: Swiper(
        itemCount: episodes.length,
        layout: SwiperLayout.STACK,
        axisDirection: AxisDirection.right,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.4,
        itemBuilder: (_, int index) {
          final episode = episodes[index];

          episode.heroId = 'swiper-${episode.id}';

          return Column(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                    alignment: Alignment.bottomCenter,
                    width: double.infinity,
                    color: const Color(0xfffafafa),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(episode.episode)),
              ),
              Expanded(
                flex: 12,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      color: const Color(0xfffafafa),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(episode.name)),
                ),
              ),
              Expanded(
                flex: 83,
                child: Hero(
                  tag: episode.heroId!,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: const FadeInImage(
                      placeholder: AssetImage('assets/no-image.jpg'),
                      image: NetworkImage(
                          'https://es.web.img3.acsta.net/pictures/18/10/31/17/34/2348073.jpg'),
                      //episode.url si fuera la imagen del capitulo
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
