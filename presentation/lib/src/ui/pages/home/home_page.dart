import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/src/ui/component/session/ui_session.dart';
import 'package:presentation/src/ui/pages/home/bloc/home_bloc_factory.dart';
import 'package:presentation/src/ui/pages/home/component/list/session_list.dart';
import 'package:presentation/src/ui/pages/home/model/home_event.dart';

import '../scanner/scanner_page.dart';
import '../settings/settings_page.dart';
import 'bloc/home_bloc.dart';
import 'model/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
        create: (context) => GetIt.I<HomeBlocFactory>().create(),
        child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          if (state is HomeStateIdle) {
            return _body(context, state.sessions, state.defaultNetworkAddress);
          } else {
            return const SizedBox();
          }
        }));
  }

  Widget _body(BuildContext context, Stream<List<UiSession>> sessions, String defaultNetworkAddress) {
    final homeBloc = context.read<HomeBloc>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Rebello"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateSessionDialog(context, defaultNetworkAddress),
          ),
          PopupMenuButton(itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.qr_code_2),
                  title: const Text('Scan to join'),
                  onTap: () =>
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ScannerPage())
                      ),
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap:  () =>
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SettingsPage())
                      ),
                ),
              ),
            ];
          }),
        ],
      ),
      body: SessionList(stream: sessions, onCreateSession: () => _showCreateSessionDialog(context, defaultNetworkAddress)),
    );
  }

  _showCreateSessionDialog(BuildContext context, String defaultNetworkAddress) {
    final homeBloc = context.read<HomeBloc>();
    showDialog(context: context, builder: (context) => _createSessionDialog(
        context,
        defaultNetworkAddress,
            (String networkAddress) => homeBloc.add(HomeEventCreateSession(networkAddress))
    ));
  }

  AlertDialog _createSessionDialog(BuildContext context, String defaultNetworkAddress, void Function(String networkAddress) joinSession) {
    final textController = TextEditingController(text: defaultNetworkAddress);

    return AlertDialog(
      title: const Text('Join room'),
      content: TextField(
        controller: textController,
        decoration: const InputDecoration(
          labelText: 'Network address',
          border: OutlineInputBorder(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            joinSession(textController.text);
            Navigator.of(context).pop();
          },
          child: const Text('Join'),
        ),
      ],
    );
  }
}
