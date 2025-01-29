part of 'device_details_bloc.dart';

sealed class DeviceDetailsEvent extends Equatable {
  const DeviceDetailsEvent();

  @override
  List<Object> get props => [];
}

class DeviceDetailsStarted extends DeviceDetailsEvent {}

class DeviceDetailsSearchUserChanged extends DeviceDetailsEvent {
  final String query;

  const DeviceDetailsSearchUserChanged({required this.query});

  @override
  List<Object> get props => [query];
}

class DeviceDetailsShareDevice extends DeviceDetailsEvent {
  final List<String> userIds;

  const DeviceDetailsShareDevice({required this.userIds});

  @override
  List<Object> get props => [userIds];

}
