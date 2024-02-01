part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class UserProfileState extends ProfileState {
  final UserEntity? user;

  const UserProfileState({required this.user});
}

final class UpdateUserFailed extends ProfileState {
  final String error;

  const UpdateUserFailed({required this.error});
}

final class UpdateUserSuccess extends ProfileState {
  final String message;

  const UpdateUserSuccess({required this.message});
}

final class SessionEndedState extends ProfileState {
  final String accessToken;

  const SessionEndedState({required this.accessToken});
}
