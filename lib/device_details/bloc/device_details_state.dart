part of 'device_details_bloc.dart';

sealed class DeviceDetailsState extends Equatable {
  const DeviceDetailsState();
  
  @override
  List<Object> get props => [];
}

final class DeviceDetailsInitial extends DeviceDetailsState {}
