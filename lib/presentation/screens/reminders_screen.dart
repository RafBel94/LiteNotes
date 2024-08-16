import 'package:flutter/material.dart';
import 'package:read_write_app/presentation/screens/providers/user_provider.dart';

class RemindersScreen extends StatelessWidget {

  RemindersScreen({super.key});

  final UserProvider userProvider = UserProvider();

  @override
  Widget build(BuildContext context) {

    final deviceSize = MediaQuery.of(context).size;

    return Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            _ReminderButton(deviceSize: deviceSize),
            _ReminderButton(deviceSize: deviceSize),
            _ReminderButton(deviceSize: deviceSize),
            _ReminderButton(deviceSize: deviceSize),
            _ReminderButton(deviceSize: deviceSize),
            _ReminderButton(deviceSize: deviceSize),
            _ReminderButton(deviceSize: deviceSize),
            _ReminderButton(deviceSize: deviceSize),
            _ReminderButton(deviceSize: deviceSize),
            _ReminderButton(deviceSize: deviceSize)
          ],
        )
      );
  }
}

class _ReminderButton extends StatelessWidget {
  const _ReminderButton({
    required this.deviceSize,
  });

  final Size deviceSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: TextButton(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
          minimumSize: WidgetStatePropertyAll(Size(deviceSize.width, 100)),
          backgroundColor: const WidgetStatePropertyAll(Color.fromARGB(25, 158, 158, 158))
          ),
        onPressed: () {
      
        },
        child: const Text('Reminder', style: TextStyle(fontSize: 25, color: Colors.white),)
      ),
    );
  }
}