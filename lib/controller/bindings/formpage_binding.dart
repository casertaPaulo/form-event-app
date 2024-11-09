import 'package:form_event_app/controller/data_controller.dart';
import 'package:form_event_app/controller/database_controller.dart';
import 'package:form_event_app/controller/formpage_controler.dart';
import 'package:get/get.dart';

class FormpageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DataController());
    Get.put(DatabaseController());
    Get.put(FormpageControler());
  }
}
