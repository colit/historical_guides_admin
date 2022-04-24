import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_state.dart';
import '../../navigation/shell_router_delegate.dart';
import 'navigation_bar/navigation_bar_web.dart';

class AppShell extends StatefulWidget {
  const AppShell({Key? key}) : super(key: key);

  @override
  _AppShellState createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late AppState appState;

  late ShellRouterDelegate _shellRouterDelegate;
  ChildBackButtonDispatcher? _backButtonDispatcher;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _shellRouterDelegate = ShellRouterDelegate(
      appState: appState = context.read<AppState>(),
    );
    _backButtonDispatcher = Router.of(context)
        .backButtonDispatcher
        ?.createChildBackButtonDispatcher();
  }

  @override
  Widget build(BuildContext context) {
    _backButtonDispatcher?.takePriority();
    return Consumer<AppState>(
      builder: ((context, value, child) {
        return Scaffold(
          body: Column(
            children: [
              Container(
                color: Colors.amberAccent,
                child: NavigationBarWeb(
                    selectedIndex: appState.selectedIndex,
                    onTap: (index) {
                      appState.setHomePage(index);
                    }),
              ),
              Expanded(
                child: Router(
                  routerDelegate: _shellRouterDelegate,
                  backButtonDispatcher: _backButtonDispatcher,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
