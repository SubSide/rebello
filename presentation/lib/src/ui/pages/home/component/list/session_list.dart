import 'package:flutter/material.dart';
import 'package:presentation/src/ui/component/session/ui_session.dart';
import 'package:presentation/src/ui/pages/call/call_page.dart';

class SessionList extends StatelessWidget {
  final Stream<List<UiSession>> stream;
  final Function() onCreateSession;

  const SessionList({super.key, required this.stream, required this.onCreateSession});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UiSession>>(
      stream: stream,
      initialData: const [],
      builder: (BuildContext context, AsyncSnapshot<List<UiSession>> snapshot) {
        final sessions = snapshot.data;
        if (snapshot.hasData && sessions != null && sessions.isNotEmpty == true) {
          print('SessionList: ${sessions.length}');
          return ListView.separated(
            itemCount: sessions.length,
            separatorBuilder: (BuildContext context, int index) => const Divider(),
            itemBuilder: (BuildContext context, int index) {
              return SessionItem(session: sessions[index]);
            },
          );
        } else {
          return Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              const Text('No sessions yet!'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onCreateSession,
                child: const Text('Create a new session'),
              )
            ]
          ));
        }
      },
    );
  }
}

class SessionItem extends StatelessWidget {
  final UiSession session;

  const SessionItem({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(session.title),
      subtitle: Text('${session.members.length} members'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CallPage(),
            settings: RouteSettings(arguments: session.id),
          )
        );
      },
    );
  }

}