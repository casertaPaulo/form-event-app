import 'package:form_event_app/controller/database_controller.dart';
import 'package:get/get.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DatabaseController());
  }
}
