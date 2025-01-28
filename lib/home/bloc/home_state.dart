part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeFailure extends HomeState {
  final String message;

  const HomeFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class HomeLoaded extends HomeState {
  final BluetoothAdapterState adapterState;
  final String? errorMessage;
  final List<ScanResult> scanResults;

  const HomeLoaded({required this.adapterState, this.errorMessage, this.scanResults = const []});

  @override
  List<Object?> get props => [adapterState, errorMessage, scanResults];

  HomeLoaded copyWith({
    BluetoothAdapterState? adapterState,
    String? errorMessage,
  }) {
    return HomeLoaded(
      adapterState: adapterState ?? this.adapterState,
      errorMessage: errorMessage,
    );
  }
}

enum SnackbarType { success, error, info }

final class HomeSnackbarState extends HomeState {
  final String message;
  final SnackbarType type;

  const HomeSnackbarState({
    required this.message,
    required this.type,
  });

  @override
  List<Object?> get props => [message, type];
}