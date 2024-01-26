import 'package:fic11_pos_apps/data/datasources/auth_local_datasources.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SaveServerKeyPage extends StatefulWidget {
  const SaveServerKeyPage({super.key});

  @override
  State<SaveServerKeyPage> createState() => _SaveServerKeyPageState();
}

class _SaveServerKeyPageState extends State<SaveServerKeyPage> {
  TextEditingController? serverKeyController;

  String serverKey = '';

  Future<void> getServerKey() async {
    serverKey = await AuthLocalDataSource().getMidtransServerKey();
  }

  @override
  void initState() {
    super.initState();
    serverKeyController = TextEditingController();
    getServerKey();
    //delay 2 detik
    Future.delayed(const Duration(seconds: 2), () {
      serverKeyController!.text = serverKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Save Server Key'),
        centerTitle: true,
      ),
      //textfield untuk input server key
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: serverKeyController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Server Key',
              ),
            ),
          ),
          //button untuk save server key
          ElevatedButton(
            onPressed: () {
              AuthLocalDataSource()
                  .saveMidtransServerKey(serverKeyController!.text);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Server Key saved'),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
