import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rooms_vital_assignment/device_details/device_details.dart';

import 'device_details_view.dart';

class DeviceDetailsPage extends StatelessWidget {
  const DeviceDetailsPage({super.key, required this.device});

  static const String routePath = "/device_details";
  static const String routeName = "device-details";

  final BluetoothDevice device;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeviceDetailsBloc(),
      child: DeviceDetailsView(device: device),
    );
  }
}
