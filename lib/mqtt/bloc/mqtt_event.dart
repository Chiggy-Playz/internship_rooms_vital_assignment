part of 'mqtt_bloc.dart';

sealed class MqttEvent extends Equatable {
  const MqttEvent();

  @override
  List<Object> get props => [];
}

class MqttConnect extends MqttEvent {}
