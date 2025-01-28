part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeLoadRequested extends HomeEvent {
  const HomeLoadRequested();
}

class HomeScanDevicesRequested extends HomeEvent {
  const HomeScanDevicesRequested();
}

class HomeConnectToDevice extends HomeEvent {
  final BluetoothDevice device;

  const HomeConnectToDevice({required this.device});
}
