import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooms_vital_assignment/core/extensions.dart';
import 'package:rooms_vital_assignment/shared_devices/shared_devices.dart';

class SharedDevicesView extends StatefulWidget {
  const SharedDevicesView({super.key});

  @override
  State<SharedDevicesView> createState() => _SharedDevicesViewState();
}

class _SharedDevicesViewState extends State<SharedDevicesView> {
  @override
  void initState() {
    super.initState();
    context.read<SharedDevicesBloc>().add(SharedDevicesLoad());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SharedDevicesBloc, SharedDevicesState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is SharedDevicesInitial || state is! SharedDevicesLoaded) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: state.data.length,
            itemBuilder: (context, index) {
              final deviceInfo = state.data[index];

              return Card(
                child: ListTile(
                  tileColor: context.colorScheme.primaryContainer,
                  title: Text(deviceInfo.name),
                  subtitle: Text(deviceInfo.id),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
