import 'package:flutter/material.dart';
import 'package:notepat/src/core/constants/data.dart';
import 'package:notepat/src/core/controllers/theme_controller.dart';
import 'package:notepat/src/core/services/preferences_service.dart';
import 'package:notepat/src/ui/pages/home_page.dart';
import 'package:notepat/src/ui/widgets/buttons/simple_buttons.dart';
import 'package:notepat/src/ui/widgets/loading_widget/loading_widget.dart';
import 'package:notepat/src/ui/widgets/loading_widget/loading_widget_controller.dart';
Color fontColor() {
  return ThemeController.instance.brightnessValue
      ? Colors.black
      : Colors.white;
}
class LandingPage extends StatelessWidget {
  LandingPage({Key? key}) : super(key: key);

  static final LANDING_PAGE_ROUTE = "landing_page";
  // ignore: unused_field
  final PreferencesService _preferencesService = PreferencesService.instance;

  Widget _image() {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/landing.png"))));
  }

  Future<void> initMethods() async {}

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final theme = ThemeController.instance;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: ThemeController.instance.background(),
          body: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(child: _image()),
                  Text(Constants.MAIN_TITLE,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold, color: ThemeController.instance.brightnessValue
      ? Colors.blueGrey
      : Colors.white70)),
                  SizedBox(height: 16),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 30),
                    child: Text(
                      Constants.SUB_TITLE,
                      style: TextStyle(color: ThemeController.instance.brightnessValue
      ? Colors.blueGrey
      : Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 100),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: MediumButton(
                        title: "Ingresar",
                        onTap: () async {
                          LoadingWidgetController.instance.loading();
                          await initMethods();
                          LoadingWidgetController.instance.close();
                          Navigator.pushNamed(
                              context, HomePage.HOME_PAGE_ROUTE);
                        }),
                  )
                ],
              )),
        ),
        ValueListenableBuilder(
            valueListenable: LoadingWidgetController.instance.loadingNotifier,
            builder: (context, bool value, Widget? child) {
              return value ? LoadingWidget() : SizedBox();
            })
      ],
    );
  }
}