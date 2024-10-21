import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/src/ui/app/model/app_event.dart';
import 'package:presentation/src/ui/pages/call/bloc/call_bloc.dart';
import 'package:presentation/src/ui/pages/call/bloc/call_bloc_factory.dart';
import 'package:presentation/src/ui/pages/call/qr/qr_share_page.dart';
import 'package:presentation/src/ui/pages/call/component/speaker_list.dart';
import 'package:presentation/src/ui/pages/call/component/record_button.dart';
import 'package:presentation/src/ui/pages/call/model/call_events.dart';

import '../../app/bloc/app_bloc.dart';
import 'model/call_state.dart';

class CallPage extends StatelessWidget {

  const CallPage({super.key});

  @override
  Widget build(BuildContext context) {
    final groupUuid = ModalRoute.of(context)!.settings.arguments as String;

    return BlocProvider<CallBloc>(
        create: (context) => GetIt.I<CallBlocFactory>().create(groupUuid),
        child: BlocBuilder<CallBloc, CallState>(
          builder: (context, state) {
            if (state is CallStateSuccess) {
              return _body(context, state);
            } else {
              return _loading(context);
            }
          },
        ));
  }

  Widget _body(BuildContext context, CallStateSuccess state) {
    final callBloc = context.read<CallBloc>();
    final appBloc = context.read<AppBloc>();

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text('Rebello - ${state.name}'),
            actions: <Widget>[
              IconButton(
                  icon: const Icon(Icons.qr_code),
                  onPressed: () {
                    callBloc.add(CallEventOpenQr());
                  }),
              IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: () => _confirmExit(context))
            ]),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _CallPageEventListener(stream: callBloc.events),
            Row(children: [
              IconButton.filled(onPressed: () => callBloc.add(CallEventOpenMemberList()), icon: const Icon(Icons.people))
            ]),
            Expanded(child: Padding(padding: const EdgeInsets.all(16), child: SpeakerList(members: state.speakers))),
            Padding(
                padding: const EdgeInsets.all(16),
                child: AspectRatio(
                    aspectRatio: 1,
                    child: SizedBox(
                        width: double.infinity,
                        child: RecordButton(
                          onPress: () {
                            appBloc.add(AppEventStartRecording(state.session));
                          },
                          onRelease: () {
                            appBloc.add(AppEventStopRecording());
                          },
                        ))))
          ],
        ));
  }

  Widget _loading(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: const Text('Rebello - Loading...')),
        body: const Center(child: CircularProgressIndicator()));
  }

  _confirmExit(BuildContext context) {
    final callBloc = context.read<CallBloc>();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text("Are you sure you want to leave the call?"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    callBloc.add(CallEventLeave());
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                  child: const Text("Yes")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"))
            ],
          );
        });
  }
}

class _CallPageEventListener extends StatefulWidget {
  final Stream<CallBlocEvent> stream;

  const _CallPageEventListener({required this.stream});

  @override
  State<StatefulWidget> createState() => _CallPageEventListenerState();
}

class _CallPageEventListenerState extends State<_CallPageEventListener> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.stream.listen((event) {
      if (event is CallBlocEventOpenQr) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QrSharePage(
                    groupUuid: event.groupUuid,
                    sessionName: event.groupName,
                    data: event.data,
                    onClose: () => Navigator.pop(context))));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}