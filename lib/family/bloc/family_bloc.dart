import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'family_event.dart';
part 'family_state.dart';

class FamilyBloc extends Bloc<FamilyEvent, FamilyState> {
  FamilyBloc() : super(FamilyInitial()) {
    on<FamilyEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
