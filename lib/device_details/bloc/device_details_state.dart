part of 'device_details_bloc.dart';

sealed class DeviceDetailsState extends Equatable {
  const DeviceDetailsState();

  @override
  List<Object?> get props => [];
}

final class DeviceDetailsInitial extends DeviceDetailsState {}

final class DeviceDetailsLoaded extends DeviceDetailsState {
  final BluetoothDevice device;
  final List<String> sharedWithEmails;
  final List<Map<String, dynamic>> searchResults;

  const DeviceDetailsLoaded(
      {required this.device,
      required this.sharedWithEmails,
      required this.searchResults});

  @override
  List<Object?> get props => [
        device,
        sharedWithEmails,
        searchResults,
      ];

  DeviceDetailsLoaded copyWith({
    BluetoothDevice? device,
    List<String>? sharedWithEmails,
    List<Map<String, dynamic>>? searchResults,
  }) {
    return DeviceDetailsLoaded(
      device: device ?? this.device,
      sharedWithEmails: sharedWithEmails ?? this.sharedWithEmails,
      searchResults: searchResults ?? this.searchResults,
    );
  }
}
