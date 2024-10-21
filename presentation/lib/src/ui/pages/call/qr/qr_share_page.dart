import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/src/ui/pages/call/qr/bloc/qr_share_bloc.dart';
import 'package:presentation/src/ui/pages/call/qr/bloc/qr_share_bloc_factory.dart';
import 'package:presentation/src/ui/pages/call/qr/model/qr_share_events.dart';
import 'package:presentation/src/ui/pages/call/qr/model/qr_share_state.dart';

import 'package:qr_flutter/qr_flutter.dart';

class QrSharePage extends StatelessWidget {
  const QrSharePage({super.key, required this.groupUuid, required this.sessionName, required this.data, required this.onClose });

  final String groupUuid;
  final String sessionName;
  final String data;
  final Function onClose;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QrShareBloc>(
        create: (context) => GetIt.I<QrShareBlocFactory>().create(groupUuid),
        child: BlocBuilder<QrShareBloc, QrShareState>(
          builder: (context, state) {
            final incomingInvitationRequest = state.incomingInvitationRequest;
            return Stack(children: [
              _page(context),
              if (incomingInvitationRequest != null) _inviteRequest(context, incomingInvitationRequest)
            ]);
          },
        ));
  }

  Widget _page(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text('Share session - $sessionName')),
        body: Container(padding: const EdgeInsets.all(16), child: QrImageView(data: data)));
  }

  Widget _inviteRequest(BuildContext context, IncomingInvitationRequest incomingInvitationRequest) {
    final qrShareBloc = context.read<QrShareBloc>();

    return AlertDialog(
      content: Text(
          "Got an incoming request from ${ incomingInvitationRequest.username } with confirmationCode: ${ incomingInvitationRequest.comparableCode }, accept?"),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              qrShareBloc.add(QrShareEventAcceptedInvite(true));
              onClose();
            },
            child: const Text("Yes")),
        TextButton(
            onPressed: () {
              qrShareBloc.add(QrShareEventAcceptedInvite(false));
              onClose();
            },
            child: const Text("No"))
      ],
    );
  }
}
