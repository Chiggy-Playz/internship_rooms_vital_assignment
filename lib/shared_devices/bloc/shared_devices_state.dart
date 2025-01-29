part of 'shared_devices_bloc.dart';

sealed class SharedDevicesState extends Equatable {
  const SharedDevicesState();

  @override
  List<Object> get props => [];
}

final class SharedDevicesInitial extends SharedDevicesState {}

class DeviceInfo extends Equatable {
  final String name;
  final String id;

  const DeviceInfo({required this.name, required this.id});

  @override
  List<Object?> get props => [name, id];

  factory DeviceInfo.fromMap(Map<String, dynamic> map) {
    return DeviceInfo(name: map["name"]!, id: map["id"]!);
  }
}

class SharedDevicesLoaded extends SharedDevicesState {
  final List<DeviceInfo> data;

  const SharedDevicesLoaded({required this.data});

  @override
  List<Object> get props => [data];
}
