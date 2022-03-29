import 'package:get/get.dart';
import 'package:post_frame/app/data/provider/provider.dart';
import 'package:post_frame/app/data/services/storage/repository.dart';
import 'package:post_frame/app/modules/home/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => HomeCtrl(
        projctRepository: ProjctRepository(projctProvider: ProjctProvider())));
  }
}
