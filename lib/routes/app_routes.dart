import 'package:form_event_app/controller/bindings/formpage_binding.dart';
import 'package:form_event_app/ui/pages/form_page.dart';
import 'package:form_event_app/ui/pages/onboarding_page.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const initial = '/';

  static final routes = [
    GetPage(
      name: '/',
      page: () => const OnboardingPage(),
    ),
    GetPage(
      name: '/form',
      page: () => const FormPage(),
      binding: FormpageBinding(),
    ),
  ];
}
