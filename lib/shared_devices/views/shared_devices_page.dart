import 'package:database_handler/database_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooms_vital_assignment/shared_devices/shared_devices.dart';

class SharedDevicesPage extends StatelessWidget {
  const SharedDevicesPage({super.key});

  static const routePath = "/shared_devices";
  static const routeName = "shared-devices";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SharedDevicesBloc(
        databaseHandler: context.read<DatabaseHandler>()
      ),
      child: const SharedDevicesView(),
    );
  }
}
