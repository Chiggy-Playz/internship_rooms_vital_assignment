import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'device_details_event.dart';
part 'device_details_state.dart';

class DeviceDetailsBloc extends Bloc<DeviceDetailsEvent, DeviceDetailsState> {
  DeviceDetailsBloc() : super(DeviceDetailsInitial()) {
    on<DeviceDetailsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
