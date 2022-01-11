import 'package:app_filmes/application/ui/loaders/loader_mixin.dart';
import 'package:app_filmes/application/ui/mesages/messages_mixin.dart';
import 'package:app_filmes/models/movie_detail_model.dart';
import 'package:app_filmes/services/movies/movies_service.dart';
import 'package:get/get.dart';

class MovieDetailController extends GetxController
    with LoaderMixin, MessagesMixin {
  final MoviesService _moviesService;
  final movie = Rxn<MovieDetailModel>();

  MovieDetailController({required MoviesService moviesService})
      : _moviesService = moviesService;

  var loading = false.obs;
  var message = Rxn<MessageModel>();

  @override
  void onInit() {
    super.onInit();
    loaderListener(loading);
    messageListener(message);
  }

  @override
  void onReady() async {
    super.onReady();

    final movieId = Get.arguments;
    loading(true);

    try {
      final movieDetailData = await _moviesService.getMovieDetail(movieId);
      movie(movieDetailData);
      loading(false);
    } catch (e, s) {
      loading(false);
      message(MessageModel.error(
          title: 'Filme',
          message: 'Erro ao buscar o filme: ${e.toString()} ${s.toString()}'));
    }
  }
}
