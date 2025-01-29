import 'package:bloc/bloc.dart';
import 'package:database_handler/database_handler.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

part 'device_details_event.dart';
part 'device_details_state.dart';

class DeviceDetailsBloc extends Bloc<DeviceDetailsEvent, DeviceDetailsState> {
  DeviceDetailsBloc(
      {required BluetoothDevice device,
      required DatabaseHandler databaseHandler})
      : _databaseHandler = databaseHandler,
        _device = device,
        super(DeviceDetailsInitial()) {
    on<DeviceDetailsStarted>(_load);
    on<DeviceDetailsSearchUserChanged>(_searchUsers);
    on<DeviceDetailsShareDevice>(_shareDevice);
  }

  final BluetoothDevice _device;
  final DatabaseHandler _databaseHandler;

  Future<void> _load(
    DeviceDetailsStarted event,
    Emitter<DeviceDetailsState> emit,
  ) async {
    emit(
      DeviceDetailsLoaded(
        device: _device,
        sharedWithEmails: await _databaseHandler.getSharedUsersEmails(
          _device.remoteId.str.replaceAll(":", ""),
        ),
        searchResults: const [],
      ),
    );
  }

  Future<void> _searchUsers(
    DeviceDetailsSearchUserChanged event,
    Emitter<DeviceDetailsState> emit,
  ) async {
    final searchResults = <Map<String, dynamic>>[];
    final currentState = (state as DeviceDetailsLoaded);
    if (event.query.isEmpty) {
      return emit(currentState.copyWith(searchResults: searchResults));
    }

    List<Map<String, dynamic>> users =
        await _databaseHandler.searchUsersByEmail(event.query);
    return emit(currentState.copyWith(searchResults: users));
  }

  Future<void> _shareDevice(
    DeviceDetailsShareDevice event,
    Emitter<DeviceDetailsState> emit,
  ) async {
    await Future.wait(
      event.userIds.map(
        (id) => _databaseHandler.shareDeviceAccess(
          _device.remoteId.str.replaceAll(":", ""),
          id,
        ),
      ),
    );
    emit(
      DeviceDetailsLoaded(
        device: _device,
        sharedWithEmails: await _databaseHandler.getSharedUsersEmails(
          _device.remoteId.str.replaceAll(":", ""),
        ),
        searchResults: const [],
      ),
    );
  }
}
