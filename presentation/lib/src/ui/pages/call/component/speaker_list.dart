import 'package:domain/session.dart';
import 'package:flutter/material.dart';

class SpeakerList extends StatelessWidget {
  const SpeakerList({super.key, required this.members});

  final List<SessionMember> members;

  @override
  Widget build(BuildContext context) {
    // Draw a scrollable list of members in two rows.
    return SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: members.sublist(0, (members.length / 2).ceil()).map((member) => _member(context, member)).toList(),
          ),
        ),
        Expanded(
          child: Column(
            children: members.sublist((members.length / 2).ceil()).map((member) => _member(context, member)).toList(),
          ),
        )
      ],
    ));
  }

  Widget _member(BuildContext context, SessionMember member) {
    // Draw the name of the member. Show to the left of it a red dot. If the member is speaking it should change to green.
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(member.name, style: const TextStyle(fontSize: 20)),
      ],
    );
  }
}
