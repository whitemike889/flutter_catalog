import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './my_app_meta.dart' as my_app_meta;
import './my_app_settings.dart';
import './themes.dart';
import './routes/about.dart';
import './routes/home.dart';

const _kHomeRoute = MyHomeRoute();
const _kAboutRoute = MyAboutRoute();

class MyMainApp extends StatelessWidget {
  const MyMainApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (!snapshot.hasData) {
          return _MySplashScreen();
        }
        return ChangeNotifierProvider<MyAppSettings>.value(
          value: MyAppSettings(snapshot.data),
          child: _MyMainApp(),
        );
      },
    );
  }
}

class _MySplashScreen extends StatelessWidget {
  const _MySplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      color: Colors.white,
      child: Center(
        child: Card(elevation: 8.0, child: FlutterLogo(size: 64.0)),
      ),
    );
  }
}

class _MyMainApp extends StatelessWidget {
  const _MyMainApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The app's root-level routing table.
    final Map<String, WidgetBuilder> _routingTable = {
      Navigator.defaultRouteName: (context) => _kHomeRoute,
      _kAboutRoute.routeName: (context) => _kAboutRoute,
      for (var route in my_app_meta.kAllRoutes)
        route.routeName: (context) => route
    };
    return MaterialApp(
      title: 'Flutter Catalog',
      theme: Provider.of<MyAppSettings>(context).isDarkMode
          ? kDartTheme
          : kLightTheme,
      routes: _routingTable,
    );
  }
}