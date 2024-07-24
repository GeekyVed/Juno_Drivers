import 'package:get/get.dart';
import 'package:juno_drivers/Info_Handler/app_info.dart';

Future<void> registerControllers() async {
  Get.put(AppInfoController());
}
