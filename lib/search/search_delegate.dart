import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/models.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty/providers/providers.dart';

class CharacterSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Search character';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _emptyContainer();
  }

  Widget _emptyContainer() {
    return const Center(
      child: Icon(
        Icons.person_4_outlined,
        color: Colors.black38,
        size: 130,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _emptyContainer();
    }

    final characterProvider =
        Provider.of<CharactersProvider>(context, listen: false);
    characterProvider.getSuggestionsByQuery(query);

    return StreamBuilder(
      stream: characterProvider.suggestionStream,
      builder: (_, AsyncSnapshot<List<Character>> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            width: double.infinity,
            height: 200,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final characters = snapshot.data!;

        return ListView.builder(
            itemCount: characters.length,
            itemBuilder: (_, int index) => _CharacterItem(characters[index]));
      },
    );
  }
}

class _CharacterItem extends StatelessWidget {
  final Character character;

  const _CharacterItem(this.character);

  @override
  Widget build(BuildContext context) {
    character.heroId = 'search-${character.id}';

    return ListTile(
      leading: Hero(
        tag: character.heroId!,
        child: FadeInImage(
          placeholder: const AssetImage('assets/no-image.jpg'),
          image: NetworkImage(character.image),
          width: 50,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(character.name),
      subtitle: Text(character.status),
      onTap: () {
        Navigator.pushNamed(context, 'details', arguments: character);
      },
    );
  }
}
