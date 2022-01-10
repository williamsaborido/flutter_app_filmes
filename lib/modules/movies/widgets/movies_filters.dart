import 'package:app_filmes/modules/movies/movies_controller.dart';
import 'package:app_filmes/modules/movies/widgets/filter_tag.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoviesFilters extends GetView<MoviesController> {
  const MoviesFilters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        scrollDirection: Axis.horizontal,
        child: Obx(() {
          return Row(
            children: controller.genres
                .map((genre) => FilterTag(
                      model: genre,
                      onPressed: () => controller.filterMoviesByGenre(genre),
                      selected: controller.genreSelected.value?.id == genre.id,
                    ))
                .toList(),
          );
        }),
      ),
    );
  }
}
