import 'package:app_filmes/application/rest_client/rest_client.dart';
import 'package:app_filmes/models/movie_detail_model.dart';
import 'package:app_filmes/models/movie_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import './movies_repository.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final RestClient _restClient;

  MoviesRepositoryImpl({required RestClient restClient})
      : _restClient = restClient;

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final result = await _restClient.get(
      'movie/popular',
      query: {
        'api_key': RemoteConfig.instance.getString('api_token'),
        'language': 'pt-br',
        'page': '1',
      },
      decoder: (data) {
        final result = data['results'];

        if (result != null) {
          return result
              .map<MovieModel>((movie) => MovieModel.fromMap(movie))
              .toList();
        }

        return <MovieModel>[];
      },
    );

    if (result.hasError) {
      throw Exception(
          'Erro ao buscar os filmes populares: ${result.statusText}');
    }

    return result.body ?? <MovieModel>[];
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    final result = await _restClient.get(
      'movie/top_rated',
      query: {
        'api_key': RemoteConfig.instance.getString('api_token'),
        'language': 'pt-br',
        'page': '1',
      },
      decoder: (data) {
        final result = data['results'];

        if (result != null) {
          return result
              .map<MovieModel>((movie) => MovieModel.fromMap(movie))
              .toList();
        }

        return <MovieModel>[];
      },
    );

    if (result.hasError) {
      throw Exception(
          'Erro ao buscar os filmes populares: ${result.statusText}');
    }

    return result.body ?? <MovieModel>[];
  }

  @override
  Future<MovieDetailModel?> getMovieDetail(int id) async {
    final result =
        await _restClient.get<MovieDetailModel?>('movie/$id', query: {
      'api_key': RemoteConfig.instance.getString('api_token'),
      'language': 'pt-br',
      'append_to_response': 'images,credits',
      'include_image_language': 'en,pt-br'
    }, decoder: (data) {
      return MovieDetailModel.fromMap(data);
    });

    if (result.hasError) {
      throw Exception('Erro ao buscar o filme: ${result.statusText}');
    }

    return result.body;
  }

  @override
  Future addOrRemoveFavorite(String userId, MovieModel movie) async {
    try {
      var favoriteCollection = FirebaseFirestore.instance
          .collection('favorites')
          .doc(userId)
          .collection('movies');

      if (movie.favorite) {
        favoriteCollection.add(movie.toMap());
      } else {
        var favoriteData = await favoriteCollection
            .where('id', isEqualTo: movie.id)
            .limit(1)
            .get();

        await favoriteData.docs.first.reference.delete();
      }
    } catch (e) {
      throw Exception('Erro ao gravar favorito: $e');
    }
  }

  @override
  Future<List<MovieModel>> getFavoriteMovies(String userId) async {
    var favoritesMovies = await FirebaseFirestore.instance
        .collection('favorites')
        .doc(userId)
        .collection('movies')
        .get();

    final listFavorites = <MovieModel>[];

    for (var movie in favoritesMovies.docs) {
      listFavorites.add(MovieModel.fromMap(movie.data()));
    }

    return listFavorites;
  }
}
