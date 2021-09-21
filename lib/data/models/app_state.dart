import 'package:flutter/foundation.dart';
import 'package:mobile_up/data/models/vk_photo.dart';
import 'package:mobile_up/services/vk_service.dart';

enum AuthStatus { initial, success, cancelled }

class AppState extends ChangeNotifier {
  AppState(this.vkService);

  final VkService vkService;
  final List<VKPhoto> photos = [];

  bool get hasToken => vkService.hasToken;

  Future<AuthStatus> checkLogin() async {
    if (vkService.hasToken) {
      notifyListeners();
      return AuthStatus.success;
    }

    return AuthStatus.initial;
  }

  Future<AuthStatus> login() async {
    final token = await vkService.logIn();
    if (token) {
      notifyListeners();
      return AuthStatus.success;
    }

    return AuthStatus.cancelled;
  }

  Future<void> logout() async {
    await vkService.logout();
    notifyListeners();
  }

  Future<void> fetchAlbum() async {
    final result = await vkService.vk.api.photos.get({
      'owner_id': -128666765,
      'album_id': 266276915,
    });
    photos.addAll(
      (result['items'] as List).map(
        (e) => VKPhoto(
          id: e['id'],
          urlSmall: e['sizes'].where((el) => el['type'] == 'm').first['url'],
          urlMedium: e['sizes'].where((el) => el['type'] == 'y').first['url'],
          urlLarge: e['sizes'].where((el) => el['type'] == 'z').first['url'],
        ),
      ),
    );
    notifyListeners();
  }
}
