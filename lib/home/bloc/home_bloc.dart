import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeLoadRequested>(_homeLoadRequested);
    on<HomeScanDevicesRequested>(_homeScanDevicesRequested);
    on<HomeConnectToDevice>(_connectToDevice);
  }

  Future<void> _homeLoadRequested(
      HomeLoadRequested event, Emitter<HomeState> emit) async {
    if (await FlutterBluePlus.isSupported == false) {
      emit(const HomeFailure("Bluetooth is not supported"));
      return;
    }

    try {
      if (!kIsWeb && Platform.isAndroid) {
        await FlutterBluePlus.turnOn();
      }
    } on FlutterBluePlusException catch (err) {
      if (FbpErrorCode.timeout.index == err.code) {
        emit(const HomeFailure("Bluetooth timed out..."));
      }
    }

    final initialAdapterState = await FlutterBluePlus.adapterState.first;
    emit(HomeLoaded(adapterState: initialAdapterState));

    add(const HomeScanDevicesRequested());

    return emit.forEach(
      FlutterBluePlus.adapterState,
      onData: (data) {
        final currentState = state;
        if (currentState is HomeLoaded) {
          return currentState.copyWith(adapterState: data);
        }

        return HomeLoaded(adapterState: data);
      },
    );
  }

  Future<void> _homeScanDevicesRequested(
      HomeScanDevicesRequested event, Emitter<HomeState> emit) async {
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    return emitScanResults(emit, state);
  }

  Future<void> _connectToDevice(
      HomeConnectToDevice event, Emitter<HomeState> emit) async {
    await event.device.connect();
    await event.device.discoverServices();
    final currentState = state;
    emit(HomeSnackbarState(
        message:
            "Connected to ${event.device.advName.isEmpty ? 'Unknown' : event.device.advName}!",
        type: SnackbarType.info));
    return emitScanResults(emit, currentState);
  }

  Future<void> emitScanResults(
      Emitter<HomeState> emit, HomeState currentState) {
    return emit.forEach(
      FlutterBluePlus.onScanResults,
      onData: (scanResults) {
        return HomeLoaded(
          adapterState: (currentState as HomeLoaded).adapterState,
          scanResults: scanResults
            ..sort(
              (a, b) => b.rssi.compareTo(a.rssi),
            ),
        );
      },
    );
  }
}
