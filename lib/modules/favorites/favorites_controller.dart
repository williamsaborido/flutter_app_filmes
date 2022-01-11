import 'package:app_filmes/models/movie_model.dart';
import 'package:get/get.dart';

import 'package:app_filmes/application/auth/auth_service.dart';
import 'package:app_filmes/services/movies/movies_service.dart';

class FavoritesController extends GetxController {
  final MoviesService _moviesService;
  final AuthService _authService;

  final movies = <MovieModel>[].obs;

  FavoritesController(
      {required MoviesService moviesService, required AuthService authService})
      : _moviesService = moviesService,
        _authService = authService;

  @override
  void onReady() {
    super.onReady();
    _getFavorites();
  }

  _getFavorites() async {
    var user = _authService.user;

    if (user != null) {
      var favorites = await _moviesService.getFavoriteMovies(user.uid);

      movies.assignAll(favorites);
    }
  }

  Future removeFavorite(MovieModel movie) async {
    var user = _authService.user;

    if (user != null) {
      await _moviesService.addOrRemoveFavorite(
          user.uid, movie.copyWith(favorite: false));
      movies.remove(movie);
    }
  }
}
