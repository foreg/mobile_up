import 'package:flutter/material.dart';
import 'package:mobile_up/app.dart';
import 'package:mobile_up/data/models/app_state.dart';
import 'package:mobile_up/services/vk_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final vkService = VkService();
  await vkService.init();

  final authModel = AppState(vkService);
  await authModel.checkLogin();

  runApp(App(authModel: authModel));
}
