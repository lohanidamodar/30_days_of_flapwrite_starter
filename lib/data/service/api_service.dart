import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:flappwrite_water_tracker/data/model/user.dart';
import 'package:flappwrite_water_tracker/data/model/water_intake.dart';
import 'package:flappwrite_water_tracker/res/app_constants.dart';

class ApiService {
  static ApiService? _instance;
  late final Client _client;
  late final Account _account;
  late final Database _db;
  late final Teams _teams;
  late final Storage _storage;
  late final Avatars _avatars;

  ApiService._internal() {
    _client = Client(
      endPoint: AppConstant.endpoint,
    ).setProject(AppConstant.project).setSelfSigned();
    _account = Account(_client);
    _db = Database(_client);
    _teams = Teams(_client);
    _storage = Storage(_client);
    _avatars = Avatars(_client);
  }

  static ApiService get instance {
    if (_instance == null) {
      _instance = ApiService._internal();
    }
    return _instance!;
  }

  Future login({required email, required password}) {
    return _account.createSession(email: email, password: password);
  }

  Future signup(
      {String? name, required String email, required String password}) {
    return _account.create(email: email, password: password, name: name ?? "");
  }

  Future<User> getUser() async {
    final res = await _account.get();
    return User.fromMap(res.data);
  }

  Future logOut() {
    return _account.deleteSession(sessionId: 'current');
  }

  Future oAuthLogin(String provider) {
    return _account.createOAuth2Session(provider: provider);
  }

  Future verifyEmail() {
    return _account.createVerification(
        url: 'http://192.168.1.64:5500/complete_verify.html');
  }

  Future listTeams() {
    return _teams.list();
  }

  Future createTeam(String name) {
    return _teams.create(name: name);
  }

  Future deleteTeam(String id) {
    return _teams.delete(teamId: id);
  }

  Future listMembers(String teamId) {
    return _teams.getMemberships(teamId: teamId);
  }

  Future addMember({
    required String teamId,
    required String email,
    required List<String> roles,
  }) {
    return _teams.createMembership(
        teamId: teamId, email: email, roles: roles, url: 'http://localhost');
  }

  Future deleteMember({required String teamId, required String membershipId}) {
    return _teams.deleteMembership(teamId: teamId, inviteId: membershipId);
  }

  Future<WaterIntake> addIntake(
      {required WaterIntake intake,
      required List<String> read,
      required List<String> write}) async {
    final res = await _db.createDocument(
        collectionId: AppConstant.entriesCollection,
        data: intake.toMap(),
        read: read,
        write: write);
    return WaterIntake.fromMap(res.data);
  }

  Future<List<WaterIntake>> getIntakes({DateTime? date}) async {
    date = date ?? DateTime.now();
    final from = DateTime(date.year, date.month, date.day, 0);
    final to = DateTime(date.year, date.month, date.day, 23, 59, 59);
    final res = await _db.listDocuments(
        collectionId: AppConstant.entriesCollection,
        filters: [
          'date>=${from.millisecondsSinceEpoch}',
          'date<=${to.millisecondsSinceEpoch}'
        ],
        orderField: 'date',
        orderType: OrderType.desc);
    print("Total: ${res.data['sum']}");
    return List<Map<String, dynamic>>.from(res.data['documents'])
        .map((e) => WaterIntake.fromMap(e))
        .toList();
  }

  Future deleteIntake(String id) async {
    return await _db.deleteDocument(
        collectionId: AppConstant.entriesCollection, documentId: id);
  }

  Future<Map<String, dynamic>> uploadFile(
      MultipartFile file, List<String> permission) async {
    final res = await _storage.createFile(
      file: file,
      read: permission,
      write: permission,
    );
    return res.data;
  }

  Future<Map<String, dynamic>> updatePrefs(Map<String, dynamic> prefs) async {
    final res = await _account.updatePrefs(prefs: prefs);
    return res.data;
  }

  Future<Uint8List> getProfilePicture(String fileId) async {
    final res =
        await _storage.getFilePreview(fileId: fileId, width: 100, height: 100);
    return res.data;
  }

  Future<Uint8List> getCountryFlag(String code) async {
    final res = await _avatars.getFlag(code: code);
    return res.data;
  }

  Future<Uint8List> getQR(String text) async {
    final res = await _avatars.getQR(text: text, size: 800);
    return res.data;
  }

  Future<Uint8List> getInitials(String name) async {
    final res = await _avatars.getInitials(name: name);
    return res.data;
  }
}
