import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rooms_vital_assignment/core/extensions.dart';
import 'package:rooms_vital_assignment/home/home.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static const routePath = "/home";
  static const routeName = "home";

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const HomeLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeSnackbarState) {
            if (state.type == SnackbarType.error) {
              context.showErrorSnackBar(state.message);
            } else {
              context.showSnackBar(state.message);
            }
          }
        },
        buildWhen: (previous, current) => current is! HomeSnackbarState,
        builder: (context, state) {
          if (state is HomeInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is HomeFailure) {
            return Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.error,
                    size: 64,
                  ),
                  Text(state.message),
                ],
              ),
            );
          }

          if (state is HomeLoaded) {
            bool adapterStateIsOk =
                state.adapterState == BluetoothAdapterState.on;
            return Column(
              children: [
                Card(
                  child: ListTile(
                    tileColor: adapterStateIsOk
                        ? context.colorScheme.primaryContainer
                        : context.colorScheme.errorContainer,
                    textColor: adapterStateIsOk
                        ? context.colorScheme.onPrimaryContainer
                        : context.colorScheme.onErrorContainer,
                    title: const Text("Bluetooth State"),
                    subtitle: Text(
                      adapterStateIsOk ? "Bluetooth is on" : "Bluetooth is off",
                    ),
                  ),
                ),
                const Gap(16),
                Text("Scan Results", style: context.textTheme.headlineLarge),
                const Gap(16),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<HomeBloc>()
                          .add(const HomeScanDevicesRequested());
                    },
                    child: ListView.separated(
                      // shrinkWrap: true,
                      // physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => const Gap(8),
                      itemCount: state.scanResults.length,
                      itemBuilder: (context, index) {
                        final scanResult = state.scanResults[index];
                        var name = scanResult.device.advName;
                        bool connected = scanResult.device.isConnected;
                        if (name.isEmpty) {
                          name = "Unknown";
                        }
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.bluetooth),
                            tileColor: context.colorScheme.primaryContainer,
                            title: Text(name),
                            subtitle: Text(scanResult.device.remoteId.str),
                            trailing: !scanResult.advertisementData.connectable
                                ? null
                                : FilledButton(
                                    onPressed: () {
                                      if (!connected) {
                                        context.read<HomeBloc>().add(
                                              HomeConnectToDevice(
                                                device: scanResult.device,
                                              ),
                                            );
                                      } else {
                                        // context.go(DeviceDetails.routePath);
                                      }
                                    },
                                    child: Text(
                                        !connected ? "Connect" : "Details"),
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }

          throw Exception("Unhandled state: $state");
        },
      ),
    );
  }
}
