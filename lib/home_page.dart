import 'dart:developer';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:local_notifications/notification_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    NotificationApi.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .30,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      bool? checkPermission =
                          await NotificationApi.checkPermission();
                      log(checkPermission.toString());
                      if (checkPermission != null && !checkPermission) {
                        _showMyDialog(context);
                      }

                      NotificationApi.sendNotification(
                        id: 1,
                        title: 'Test',
                        body: 'Test Body',
                        payload: 'This is the payload',
                      );
                    },
                    child: const Text('Simple Notification'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Scheduled Notification'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Remove Notification'),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Allow Permission to show Notification'),
          actions: [
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.cancel),
                label: const Text('Cancel')),
            ElevatedButton.icon(
                onPressed: () {
                  AppSettings.openAppSettings(
                      type: AppSettingsType.notification);
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.check),
                label: const Text('Allow')),
          ],
        );
      },
    );
  }
}
