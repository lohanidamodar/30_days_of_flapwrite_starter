import 'package:appwrite/appwrite.dart';
import 'package:flappwrite_water_tracker/data/model/team.dart';
import 'package:flappwrite_water_tracker/data/service/api_service.dart';
import 'package:flappwrite_water_tracker/pages/team_details.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Team> teams = [];

  @override
  void initState() {
    super.initState();
    _getTeams();
  }

  _getTeams() async {
    try {
      final res = await ApiService.instance.listTeams();
      teams =
          List<Team>.from(res.data["teams"].map((team) => Team.fromMap(team)));
      setState(() {});
    } on AppwriteException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Unknown error getting teams"),
        ),
      );
    }
  }

  _delete(String id) async {
    try {
      await ApiService.instance.deleteTeam(id);
      _getTeams();
    } on AppwriteException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Unknown error deleting team"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ElevatedButton(
            onPressed: () async {
              try {
                final res = await ApiService.instance.createTeam("Team 2");
                final team = Team.fromMap(res.data);
                setState(() {
                  teams.add(team);
                });
              } on AppwriteException catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.message ?? "Unknown error"),
                  ),
                );
              }
            },
            child: Text("Create Team"),
          ),
          ...teams.map(
            (team) => ListTile(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TeamDetails(team: team),
                ),
              ),
              title: Text(team.name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("${team.sum}"),
                  IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _delete(team.id))
                ],
              ),
            ),
          ),

          /* ElevatedButton(
              onPressed: () async {
                try {
                  await ApiService.instance.verifyEmail();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Verification email sent")));
                } on AppwriteException catch (e) {
                  print(e.message);
                }
              },
              child: Text("Verify email")) */
        ],
      ),
    );
  }
}
