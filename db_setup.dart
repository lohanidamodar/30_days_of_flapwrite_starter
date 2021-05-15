import 'package:dart_appwrite/dart_appwrite.dart';

Client client = Client(endPoint: "https://demo.appwrite.io/v1")
    .setProject('607b7f4a080c8')
    .setKey(
        "35f1615cce884d6e4c91882514850bef084916ad55381445c9ed298f28f535c089e37716ffd5e1d75c8aa17ee92fb7df53ba9c651025b7735d3c8a96dfb1572097f4c80ff4a26d2eb03eccd5ec10a6deafb5064d36989f477de4933dafac737b17b22d659dc05c579960726413306b22efbb370aac8d202e31e5b9d3ccbd4ba4");
Database db = Database(client);

void main() async {
  final collections = await getCollections();

  bool exists = false;
  if (collections != null) {
    collections.forEach((collection) {
      if (collection['name'] == "Entries") {
        exists = true;
      }
    });
  }

  if (!exists)
    await createCollection();
  else
    print("Collection already exists");
}

createCollection() async {
  try {
    final res = await db.createCollection(name: 'Entries', read: [
      'role:member'
    ], write: [
      'role:member'
    ], rules: [
      {
        "key": "user_id",
        "label": "User id",
        "type": "text",
        "default": "",
        "array": false,
        "required": true,
      },
      {
        "key": "amount",
        "label": "Amount",
        "type": "numeric",
        "default": "",
        "array": false,
        "required": true,
      },
      {
        "key": "date",
        "label": "Date",
        "type": "numeric",
        "default": "",
        "array": false,
        "required": true,
      },
    ]);
    print(res.data);
    print("Collection entries created");
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<List?> getCollections() async {
  try {
    final res = await db.listCollections();
    return res.data["collections"];
  } on AppwriteException catch (e) {
    print(e.message);
    return null;
  }
}
