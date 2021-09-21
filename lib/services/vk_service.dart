import 'package:flutter_login_vk/flutter_login_vk.dart';
import 'package:vkio/main.dart';

class VkService {
  static const _appId = '7947271';
  static const _scope = [VKScope.email, VKScope.friends];
  late final VKLogin vkLogin;
  VK? _vk;
  VKAccessToken? _accessToken;

  bool get hasToken => _accessToken != null;

  VK get vk {
    _vk ??= VK(token: _accessToken!.token, language: LanguageType.RU);
    return _vk!;
  }

  Future<void> init() async {
    vkLogin = VKLogin();
    await vkLogin.initSdk(_appId, scope: _scope);
    if (await vkLogin.isLoggedIn) {
      _accessToken = await vkLogin.accessToken;
    }
  }

  Future<bool> logIn() async {
    final res = await vkLogin.logIn(scope: _scope);

    if (res.isValue) {
      if (res.asValue!.value.isCanceled) {
        return false;
      } else {
        _accessToken = res.asValue!.value.accessToken;
        return true;
      }
    }
    return false;
  }

  Future<void> logout() {
    _accessToken = null;
    return vkLogin.logOut();
  }
}
