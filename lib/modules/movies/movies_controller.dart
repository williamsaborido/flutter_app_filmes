import 'package:app_filmes/application/ui/mesages/messages_mixin.dart';
import 'package:app_filmes/models/genre_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:app_filmes/services/genres/genres_service.dart';

class MoviesController extends GetxController with MessagesMixin {
  final GenresService _genresService;
  final _message = Rxn<MessageModel>();
  final genres = <GenreModel>[].obs;

  MoviesController({required GenresService genresService})
      : _genresService = genresService;

  @override
  void onReady() async {
    super.onReady();
    messageListener(_message);
    try {
      final result = await _genresService.getGenres();
      genres.assignAll(result);
    } catch (e, s) {
      debugPrint('Erro: ${e} - ${s}');
      _message(MessageModel.error(
          title: 'Gêneros',
          message: 'Erro ao buscar os gêneros: ${e.toString()}'));
    }
  }
}
