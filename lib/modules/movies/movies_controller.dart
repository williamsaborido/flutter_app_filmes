import 'package:app_filmes/application/ui/mesages/messages_mixin.dart';
import 'package:app_filmes/models/genre_model.dart';
import 'package:app_filmes/models/movie_model.dart';
import 'package:app_filmes/services/movies/movies_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:app_filmes/services/genres/genres_service.dart';

class MoviesController extends GetxController with MessagesMixin {
  final GenresService _genresService;
  final MoviesService _moviesService;
  final _message = Rxn<MessageModel>();

  final genres = <GenreModel>[].obs;
  final popularMovies = <MovieModel>[].obs;
  final topRatedMovies = <MovieModel>[].obs;

  var popularMoviesOriginal = <MovieModel>[];
  var topRatedMoviesOriginal = <MovieModel>[];

  final genreSelected = Rxn<GenreModel>();

  MoviesController(
      {required GenresService genresService,
      required MoviesService moviesService})
      : _genresService = genresService,
        _moviesService = moviesService;

  @override
  void onReady() async {
    super.onReady();

    messageListener(_message);

    try {
      final genresData = await _genresService.getGenres();
      genres.assignAll(genresData);

      final popularMoviesData = await _moviesService.getPopularMovies();
      popularMovies.assignAll(popularMoviesData);
      popularMoviesOriginal = popularMoviesData;

      final topRatedMoviesData = await _moviesService.getTopRatedMovies();
      topRatedMovies.assignAll(topRatedMoviesData);
      topRatedMoviesOriginal = topRatedMoviesData;
    } catch (e, s) {
      debugPrint('Erro: $e - $s');
      _message(MessageModel.error(
          title: 'Gêneros',
          message: 'Erro ao carregar dados da página : ${e.toString()}'));
    }
  }

  void filterByName(String val) {
    if (val.isEmpty) {
      popularMovies.assignAll(popularMoviesOriginal);
      topRatedMovies.assignAll(topRatedMoviesOriginal);
    } else {
      var newPopularMovies = popularMoviesOriginal.where(
          (movie) => movie.title.toLowerCase().contains(val.toLowerCase()));

      var newTopRatedMovies = topRatedMoviesOriginal.where(
          (movie) => movie.title.toLowerCase().contains(val.toLowerCase()));

      popularMovies.assignAll(newPopularMovies);
      topRatedMovies.assignAll(newTopRatedMovies);
    }
  }

  void filterMoviesByGenre(GenreModel? genreModel) {
    var genreFilter = genreModel;

    if (genreFilter?.id == genreSelected.value?.id) {
      genreFilter = null;
    }

    genreSelected.value = genreFilter;

    if (genreFilter != null) {
      var newPopularMovies = popularMoviesOriginal
          .where((movie) => movie.genres.contains(genreFilter?.id));

      var newTopRatedMovies = topRatedMoviesOriginal
          .where((movie) => movie.genres.contains(genreFilter?.id));

      popularMovies.assignAll(newPopularMovies);
      topRatedMovies.assignAll(newTopRatedMovies);
    } else {
      popularMovies.assignAll(popularMoviesOriginal);
      topRatedMovies.assignAll(topRatedMoviesOriginal);
    }
  }
}
