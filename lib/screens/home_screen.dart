import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rick_and_morty/providers/providers.dart';
import 'package:rick_and_morty/search/search_delegate.dart';
import 'package:rick_and_morty/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final episodesProvider = Provider.of<EpisodesProvider>(context);
    final charactersProvider = Provider.of<CharactersProvider>(context);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Rick and Morty'),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.search_outlined),
              onPressed: () {
                showSearch(
                    context: context, delegate: CharacterSearchDelegate());
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CardSwiper(episodes: episodesProvider.onDisplay),
              CharacterSlider(
                character: charactersProvider.characters,
                title: 'Characters', // opcional
              ),
            ],
          ),
        ));
  }
}
