import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rooms_vital_assignment/core/extensions.dart';
import 'package:rooms_vital_assignment/device_details/device_details.dart';
import 'dart:convert' show utf8;

class DeviceDetailsView extends StatefulWidget {
  const DeviceDetailsView({super.key});


  @override
  State<DeviceDetailsView> createState() => _DeviceDetailsViewState();
}

class _DeviceDetailsViewState extends State<DeviceDetailsView> {

  @override
  void initState() {
    super.initState();
    context.read<DeviceDetailsBloc>().add(DeviceDetailsStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeviceDetailsBloc, DeviceDetailsState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is DeviceDetailsInitial) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final device = (state as DeviceDetailsLoaded).device;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Device Details"),
            actions: [
              IconButton(
                icon: const Icon(Icons.bluetooth_disabled),
                onPressed: () async {
                  await device.disconnect();
                  if (context.mounted) {
                    context.pop();
                  }
                },
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    child: ListTile(
                      title: const Text("Remote Id"),
                      subtitle: Text(device.remoteId.str),
                    ),
                  ),
                  StreamBuilder(
                    stream: device.connectionState,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }

                      final data = snapshot.data;
                      final connected =
                          data == BluetoothConnectionState.connected;
                      return Card(
                        child: ListTile(
                          title: const Text("Connection Status"),
                          tileColor: connected
                              ? context.colorScheme.primaryContainer
                              : context.colorScheme.errorContainer,
                          textColor: connected
                              ? context.colorScheme.onPrimaryContainer
                              : context.colorScheme.onErrorContainer,
                          subtitle:
                              Text(connected ? "Connected" : "Disconnected"),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  Text(
                    "Shared with",
                    style: context.textTheme.displaySmall,
                  ),
                  if (state.sharedWithEmails.isNotEmpty)
                    Column(
                      children: state.sharedWithEmails
                          .map((email) => Chip(
                                label: Text(email),
                              ))
                          .toList(),
                    )
                  else
                    const Text("Shared with nobody yet..."),
                  const Gap(16),
                  FilledButton.icon(
                    icon: const Icon(Icons.share),
                    label: const Text("Share"),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (ctx) => BlocProvider.value(
                          value: context.read<DeviceDetailsBloc>(),
                          child: const ShareDeviceModal(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  Text(
                    "Services",
                    style: context.textTheme.displaySmall,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => const Gap(8),
                    itemCount: device.servicesList.length,
                    itemBuilder: (context, index) {
                      final service = device.servicesList[index];

                      return ExpansionTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: context.colorScheme.onSurface)),
                        title: const Text("Service"),
                        subtitle: Text("0x${service.uuid.str}"),
                        children: service.characteristics.map((characteristic) {
                          return ListTile(
                            leading: const Icon(Icons.info),
                            title: const Text("Characteristic"),
                            subtitle: characteristic.properties.read
                                ? StreamBuilder(
                                    stream: characteristic.onValueReceived,
                                    builder: (context, snapshot) {
                                      var value =
                                          "0x${characteristic.uuid.str}";
                                      if (!snapshot.hasData) {
                                        return Text(value);
                                      }

                                      final data = snapshot.data;
                                      final decoded = utf8.decode(data!);

                                      return Text("$value\n0x$decoded");
                                    },
                                  )
                                : Text(
                                    "0x${characteristic.uuid.str}\nNot Readable"),
                            onTap: characteristic.properties.read
                                ? characteristic.read
                                : null,
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            label: const Text("Get Services"),
            icon: const Icon(Icons.search),
            onPressed: () async {
              await device.discoverServices();
              setState(() {});
            },
          ),
        );
      },
    );
  }
}
