import 'package:appwrite/appwrite.dart';
import 'package:flappwrite_water_tracker/data/model/team.dart';
import 'package:flappwrite_water_tracker/data/model/team_member.dart';
import 'package:flutter/material.dart';
import 'package:flappwrite_water_tracker/data/service/api_service.dart';

class TeamDetails extends StatefulWidget {
  final Team team;

  const TeamDetails({Key? key, required this.team}) : super(key: key);

  @override
  _TeamDetailsState createState() => _TeamDetailsState();
}

class _TeamDetailsState extends State<TeamDetails> {
  List<TeamMember> members = [];
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _getMembers();
  }

  _getMembers() async {
    try {
      final res = await ApiService.instance.listMembers(widget.team.id);
      members = List<TeamMember>.from(
          res.data["memberships"].map((team) => TeamMember.fromMap(team)));
      setState(() {});
    } on AppwriteException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Unknown error getting teams"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ...members.map(
            (member) => ListTile(
              title: Text(member.email),
              subtitle: Text(member.confirm ? "Confirmed" : "Not Confirmed"),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  //delete membership
                  try {
                    await ApiService.instance.deleteMember(
                        teamId: widget.team.id, membershipId: member.id);
                    _getMembers();
                  } on AppwriteException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text(e.message ?? "Unknown error deleting member"),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          //invite new member
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text("Invite member"),
                    content: TextField(
                      controller: _controller,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () async {
                          //save
                          final email = _controller.text;
                          try {
                            await ApiService.instance.addMember(
                              teamId: widget.team.id,
                              email: email,
                              roles: ['member'],
                            );
                            _getMembers();
                            Navigator.pop(context);
                          } on AppwriteException catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    e.message ?? "Unknown error adding member"),
                              ),
                            );
                          }
                        },
                        child: Text("Invite"),
                      ),
                    ],
                  ));
        },
      ),
    );
  }
}
