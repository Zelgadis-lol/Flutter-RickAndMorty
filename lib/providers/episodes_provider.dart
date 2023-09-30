import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:rick_and_morty/helpers/debouncer.dart';
import 'package:rick_and_morty/models/models.dart';
import 'package:rick_and_morty/providers/constants.dart';

class EpisodesProvider extends ChangeNotifier {
  List<Episode> onDisplay = [];
  Map<int, List<Characters>> episodeCast = {};

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  EpisodesProvider() {
    getOnDisplay();
  }

  getOnDisplay() async {
    List<Map<String, dynamic>> objects =
        await getAllData('${Constants.baseURL}${Constants.episodeEndpoint}');

    onDisplay = List<Episode>.from(objects.map((x) => Episode.fromJson(x)));

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
}
