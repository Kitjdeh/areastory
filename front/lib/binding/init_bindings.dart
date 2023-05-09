import 'package:front/controllers/bottom_nav_controller.dart';
import 'package:get/get.dart';

class InitBinding extends Bindings{
  InitBinding({required this.userId});
  String userId;

  @override
  void dependencies(){
    Get.put(BottomNavController(userId: userId), permanent: true);
  }
}