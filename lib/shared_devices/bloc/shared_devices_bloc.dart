import 'package:bloc/bloc.dart';
import 'package:database_handler/database_handler.dart';
import 'package:equatable/equatable.dart';

part 'shared_devices_event.dart';
part 'shared_devices_state.dart';

class SharedDevicesBloc extends Bloc<SharedDevicesEvent, SharedDevicesState> {
  SharedDevicesBloc({required DatabaseHandler databaseHandler})
      : _databaseHandler = databaseHandler,
        super(SharedDevicesInitial()) {
    on<SharedDevicesLoad>(_load);
  }

  final DatabaseHandler _databaseHandler;

  Future<void> _load(
      SharedDevicesLoad event, Emitter<SharedDevicesState> emit) async {
    return emit(
      SharedDevicesLoaded(
        data: (await _databaseHandler.getSharedDevices())
            .map((d) => DeviceInfo.fromMap(d))
            .toList(),
      ),
    );
  }
}
