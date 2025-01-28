part of 'mqtt_bloc.dart';

sealed class MqttState extends Equatable {
  const MqttState();

  @override
  List<Object> get props => [];
}

final class MqttInitial extends MqttState {}

final class MqttLoaded extends MqttState {

  const MqttLoaded({required this.messages});

  final List<String> messages;

  @override
  List<Object> get props => [messages];

}
