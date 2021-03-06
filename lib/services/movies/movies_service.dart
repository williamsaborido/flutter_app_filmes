import 'package:app_filmes/models/movie_detail_model.dart';
import 'package:app_filmes/models/movie_model.dart';

abstract class MoviesService {
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getTopRatedMovies();
  Future<MovieDetailModel?> getMovieDetail(int id);
  Future addOrRemoveFavorite(String userId, MovieModel movie);
  Future<List<MovieModel>> getFavoriteMovies(String userId);
}
