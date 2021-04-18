import 'package:flutter/material.dart';
import 'package:atdc_logbook/SplashPage.dart';
import 'package:atdc_logbook/HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Sheet Demo',
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
      ),
      initialRoute: SplashPage.routeName,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case HomePage.routeName:
            {
              return MaterialPageRoute(builder: (context) {
                return HomePage(
                  CarList: settings.arguments,
                );
              });
            }
          default:
            {
              return MaterialPageRoute(builder: (context) {
                return SplashPage();
              });
            }
        }
      },
    );
  }
}
