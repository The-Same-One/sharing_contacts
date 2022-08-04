import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:sharing_contacts/api/firestore_api.dart';
import 'package:sharing_contacts/contact_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sharing_contacts/main.dart';


class SharingPage extends StatefulWidget {
  const SharingPage({Key? key}) : super(key: key);

  @override
  _SharingPageState createState() => _SharingPageState();
}

class _SharingPageState extends State<SharingPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();

    askContactsPermission();
  }

  Future askContactsPermission() async {
    final permission = await ContactUtils.getContactPermission();

    switch (permission) {
      case PermissionStatus.granted:
        uploadContacts();
        break;
      case PermissionStatus.permanentlyDenied:
        goToHome();
        break;
      default:
        _scaffoldKey.currentState!.showSnackBar(const SnackBar(
          content: Text("Please allow to upload contacts"),
          duration: Duration(seconds: 3),
        ));
        break;
    }
  }

  Future uploadContacts() async{
    final contacts = (await ContactsService.getContacts(withThumbnails: false)).toList();

    await FirestoreApi.uploadContacts(contacts);

    // ignore: avoid_print
    print('DONE');
  }

  void goToHome() => Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) => const MyHomePage(title: 'Flutter Demo')),
      ModalRoute.withName('/'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("MAIN APP",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.amberAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(onPressed: () => askContactsPermission(),
              child: const Text(
                "DO SOMETHING",
                style: TextStyle(color: Colors.black),
              ),
              height: 40,
              minWidth: 80,
              color: Colors.amberAccent,
            )
          ],
        ),
      ),
    );
  }
}

