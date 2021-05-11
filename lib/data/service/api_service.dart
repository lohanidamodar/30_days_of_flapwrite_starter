import 'package:appwrite/appwrite.dart';
import 'package:flappwrite_water_tracker/data/model/user.dart';
import 'package:flappwrite_water_tracker/res/app_constants.dart';

class ApiService {
  static ApiService? _instance;
  late final Client _client;
  late final Account _account;
  late final Database _db;

  ApiService._internal() {
    _client = Client(
      endPoint: AppConstant.endpoint,
    ).setProject(AppConstant.project).setSelfSigned();
    _account = Account(_client);
    _db = Database(_client);
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
}
