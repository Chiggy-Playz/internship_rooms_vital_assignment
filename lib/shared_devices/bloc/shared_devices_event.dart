part of 'shared_devices_bloc.dart';

sealed class SharedDevicesEvent extends Equatable {
  const SharedDevicesEvent();

  @override
  List<Object> get props => [];
}

class SharedDevicesLoad extends SharedDevicesEvent {}
