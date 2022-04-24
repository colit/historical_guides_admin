import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
// import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:provider/provider.dart';

import 'core/app_state.dart';
import 'navigation/app_route_information_parser.dart';
import 'navigation/root_router_delegate.dart';
import 'providers.dart';

void main() {
  dotenv.load(fileName: '.env').then((value) => Parse()
      .initialize(
        dotenv.env['APP_ID']!,
        dotenv.env['PARSE_SERVER']!,
        masterKey: dotenv.env['MASTER_KEY']!,
        clientKey: dotenv.env['CLIENT_KEY']!,
      )
      .then((value) => runApp(const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Builder(builder: (context) {
        final appState = context.read<AppState>();
        return MaterialApp.router(
          title: 'Hirtorical Guide Admin',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routeInformationParser: AppRouteInformationParser(appState: appState),
          routerDelegate: RootRouterDelegate(appState: appState),
        );
      }),
    );
  }
}
