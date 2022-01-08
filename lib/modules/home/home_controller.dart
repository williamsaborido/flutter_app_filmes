import 'package:app_filmes/services/login/login_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static const NAVIGATOR_KEY = 1;
  static const INDEX_PAGE_EXIT = 2;

  final LoginService _loginService;
  final pages = ['/movies', '/favorites'];
  final _pageIndex = 0.obs;

  int get pageIndex => _pageIndex.value;

  HomeController({required LoginService loginService})
      : _loginService = loginService;

  void goToPage(int page) {
    _pageIndex(page);

    if (page == INDEX_PAGE_EXIT) {
      _loginService.logout();
    } else {
      Get.offNamed(pages[page], id: NAVIGATOR_KEY);
    }
  }
}
