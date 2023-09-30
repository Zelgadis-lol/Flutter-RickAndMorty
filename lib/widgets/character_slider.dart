import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/models.dart';

class CharacterSlider extends StatelessWidget {
  final List<Character> character;
  final String? title;

  const CharacterSlider({
    Key? key,
    required this.character,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                title!,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          const SizedBox(height: 5),
          Expanded(
            child: (character.isEmpty)
                ? const SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: character.length,
                    itemBuilder: (_, int index) => _CharacterPoster(
                        character[index],
                        '$title-$index-${character[index].id}'),
                  ),
          ),
        ],
      ),
    );
  }
}

class _CharacterPoster extends StatelessWidget {
  final Character character;
  final String heroId;

  const _CharacterPoster(this.character, this.heroId);

  @override
  Widget build(BuildContext context) {
    character.heroId = heroId;

    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, 'details', arguments: character),
            child: Hero(
              tag: character.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(character.image),
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            character.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
