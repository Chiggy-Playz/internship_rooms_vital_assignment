part of 'family_bloc.dart';

sealed class FamilyState extends Equatable {
  const FamilyState();
  
  @override
  List<Object> get props => [];
}

final class FamilyInitial extends FamilyState {}
