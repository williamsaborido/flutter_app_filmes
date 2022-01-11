import 'package:app_filmes/application/ui/loaders/loader_mixin.dart';
import 'package:app_filmes/application/ui/mesages/messages_mixin.dart';
import 'package:app_filmes/services/login/login_service.dart';
import 'package:get/get.dart';

class LoginController extends GetxController with LoaderMixin, MessagesMixin {
  final LoginService _loginService;
  final loading = false.obs;
  final message = Rxn<MessageModel>();

  LoginController({required LoginService loginService})
      : _loginService = loginService;

  @override
  void onInit() {
    super.onInit();
    loaderListener(loading);
    messageListener(message);
  }

  Future login() async {
    try {
      loading(true);
      await _loginService.login();
      loading(false);
      message(MessageModel.info(
          title: 'Sucesso', message: 'Login efetuado com sucesso'));
    } catch (e) {
      loading(false);
      message(MessageModel.error(
          title: 'Erro', message: 'Erro ao realizar o login'));
    }
  }
}
