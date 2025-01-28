import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mqtt_handler/mqtt_handler.dart';

part 'mqtt_event.dart';
part 'mqtt_state.dart';

class MqttBloc extends Bloc<MqttEvent, MqttState> {
  MqttBloc({required MqttHandler handler})
      : _handler = handler,
        super(MqttInitial()) {
    on<MqttConnect>(_connect);
  }

  final MqttHandler _handler;
  var messages = <String>[];

  Future<void> _connect(MqttConnect event, Emitter<MqttState> emit) async {
    await _handler.connect();
    _handler.subscribe("chiggy_testing");

    emit(const MqttLoaded(messages: []));

    return emit.forEach(
      _handler.updates,
      onData: (data) {
        final receivedMessage = data[0];
        final publishedMessage =
            (receivedMessage.payload as MqttPublishMessage);
        final messageValue = MqttPublishPayload.bytesToStringAsString(
            publishedMessage.payload.message);

        messages.add(messageValue);
        if (messages.length > 100) {
          messages.removeAt(0);
        }
        return MqttLoaded(
          messages: messages.reversed.toList(),
        );
      },
    );
  }
}
