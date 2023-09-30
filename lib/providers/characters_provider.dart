import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:rick_and_morty/helpers/debouncer.dart';
import 'package:rick_and_morty/models/models.dart';
import 'package:rick_and_morty/providers/constants.dart';

class CharactersProvider extends ChangeNotifier {
  List<Character> characters = [];

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  final StreamController<List<Character>> _suggestionStreamContoller =
      StreamController.broadcast();
  Stream<List<Character>> get suggestionStream =>
      _suggestionStreamContoller.stream;

  CharactersProvider() {
    getOnDisplay();
  }

  getOnDisplay() async {
    List<Map<String, dynamic>> objects =
        await getAllData('${Constants.baseURL}${Constants.characterEndpoint}');

    characters =
        List<Character>.from(objects.map((x) => Character.fromJson(x)));

    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getAllData(String url) async {
    final Dio dio = Dio();
    try {
      List<Map<String, dynamic>> allData = [];
      String? nextUrl = url;
      while (nextUrl != null) {
        var response = await dio.get(nextUrl);
        try {
          Info info = Info.fromJson(response.data["info"]);
          nextUrl = info.next;
          allData.addAll(
              List<Map<String, dynamic>>.from(response.data["results"]));
        } catch (e) {
          allData.addAll(List<Map<String, dynamic>>.from(response.data));
          nextUrl = null;
        }
      }

      return allData;
    } on DioException {
      rethrow;
    }
  }

  Future<List<Character>> searchCharacter(String query) async {
    var prefs = '?name=$query';

    List<Map<String, dynamic>> objects = await getAllData(
        '${Constants.baseURL}${Constants.characterEndpoint}$prefs');

    return List<Character>.from(objects.map((x) => Character.fromJson(x)));
  }

  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      // print('Tenemos valor a buscar: $value');
      final results = await searchCharacter(value);
      _suggestionStreamContoller.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 501))
        .then((_) => timer.cancel());
  }
}
