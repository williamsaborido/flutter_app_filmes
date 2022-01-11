import 'package:app_filmes/application/auth/auth_service.dart';
import 'package:app_filmes/application/ui/mesages/messages_mixin.dart';
import 'package:app_filmes/models/genre_model.dart';
import 'package:app_filmes/models/movie_model.dart';
import 'package:app_filmes/services/movies/movies_service.dart';
import 'package:get/get.dart';

import 'package:app_filmes/services/genres/genres_service.dart';

class MoviesController extends GetxController with MessagesMixin {
  final GenresService _genresService;
  final MoviesService _moviesService;
  final AuthService _authService;
  final _message = Rxn<MessageModel>();

  final genres = <GenreModel>[].obs;
  final popularMovies = <MovieModel>[].obs;
  final topRatedMovies = <MovieModel>[].obs;

  var popularMoviesOriginal = <MovieModel>[];
  var topRatedMoviesOriginal = <MovieModel>[];

  final genreSelected = Rxn<GenreModel>();

  MoviesController(
      {required GenresService genresService,
      required MoviesService moviesService,
      required AuthService authService})
      : _genresService = genresService,
        _moviesService = moviesService,
        _authService = authService;

  @override
  void onReady() async {
    super.onReady();

    messageListener(_message);

    try {
      final genresData = await _genresService.getGenres();

      genres.assignAll(genresData);

      getMovies();
    } catch (e) {
      _message(MessageModel.error(
          title: 'Gêneros', message: 'Erro ao carregar dados da página : $e'));
    }
  }

  Future getMovies() async {
    try {
      final favorites = await getFavorites();

      var popularMoviesData = await _moviesService.getPopularMovies();
      var topRatedMoviesData = await _moviesService.getTopRatedMovies();

      popularMoviesData = popularMoviesData.map((movie) {
        if (favorites.containsKey(movie.id)) {
          return movie.copyWith(favorite: true);
        } else {
          return movie.copyWith(favorite: false);
        }
      }).toList();

      topRatedMoviesData = topRatedMoviesData.map((movie) {
        if (favorites.containsKey(movie.id)) {
          return movie.copyWith(favorite: true);
        } else {
          return movie.copyWith(favorite: false);
        }
      }).toList();

      popularMovies.assignAll(popularMoviesData);
      popularMoviesOriginal = popularMoviesData;
      topRatedMovies.assignAll(topRatedMoviesData);
      topRatedMoviesOriginal = topRatedMoviesData;
    } catch (e) {
      rethrow;
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

  Future favoriteMovie(MovieModel movie) async {
    final user = _authService.user;

    if (user != null) {
      var newMovie = movie.copyWith(favorite: !movie.favorite);
      await _moviesService.addOrRemoveFavorite(user.uid, newMovie);
      getMovies();
    }
  }

  Future<Map<int, MovieModel>> getFavorites() async {
    var user = _authService.user;

    if (user != null) {
      final favorites = await _moviesService.getFavoriteMovies(user.uid);
      return <int, MovieModel>{for (var fav in favorites) fav.id: fav};
    }

    return <int, MovieModel>{};
  }
}
