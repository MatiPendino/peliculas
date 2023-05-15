
import 'package:flutter/cupertino.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/screens/screens.dart';

class AppRoutes {
  static const initialRoute = 'home';
  static final routes = <ScreenRoutes>[
    ScreenRoutes(routeName: 'home', screen: const HomeScreen()),
    ScreenRoutes(routeName: 'details', screen: const DetailsScreen())
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes(){
    Map<String, Widget Function(BuildContext)> appRoutes = {};
    appRoutes.addAll({'home': (BuildContext context) => const HomeScreen()});

    for (final route in routes){
      appRoutes.addAll({route.routeName: (BuildContext context) => route.screen});
    }

    return appRoutes;
  }
}