
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/src/extensions/string.dart';
import 'package:presentation/src/ui/pages/settings/bloc/settings_bloc_factory.dart';
import 'package:presentation/src/ui/pages/settings/model/settings_state.dart';
import 'package:settings_ui/settings_ui.dart';

import 'bloc/settings_bloc.dart';
import 'model/settings_event.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    title: const Text('Settings')
    ),
    body: BlocProvider<SettingsBloc>(
        create: (context) => GetIt.I<SettingsBlocFactory>().create(),
        child: BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
          if (state is SettingsLoaded) {
            return _settings(context, state);
          } else {
            return const SizedBox();
          }
        }))
    );
  }


  Widget _settings(BuildContext context, SettingsLoaded state) {
    final settingsBloc = context.read<SettingsBloc>();
    return SettingsList(sections: [
      SettingsSection(
          title: const Text('Main'),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              title: const Text('Username'),
              leading: const Icon(Icons.person),
              onPressed: (BuildContext context) => showDialog(
                  context: context,
                  builder: (context) => _editTextPopup(context, 'Username', state.username, (value) => settingsBloc.add(SettingsEventSetUserName(value)))),
              value: Text(state.username),
            ),
            SettingsTile.navigation(
              title: const Text('Default network address'),
              leading: const Icon(Icons.public),
              onPressed: (BuildContext context) => showDialog(
                  context: context,
                  builder: (context) => _editTextPopup(context, 'Default network address', state.defaultNetworkAddress, (value) => settingsBloc.add(SettingsEventSetDefaultNetworkAddress(value)))),
              value: Text(state.defaultNetworkAddress.ifEmpty('None')),
            ),
            SettingsTile.switchTile(
                title: const Text('Listen while speaking'),
                leading: const Icon(Icons.headset_mic),
                initialValue: state.listenWhileSpeaking,
                onToggle: (bool value) => settingsBloc.add(SettingsEventSetListenWhileSpeaking(value))),

          ])
    ]);
  }

  Widget _editTextPopup(BuildContext context, String title, String initialValue, Function(String) onDone) {
    final controller = TextEditingController(text: initialValue);
    return AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onDone(controller.text);
            Navigator.pop(context);
          },
          child: const Text('Done'),
        ),
      ],
    );
  }
}
