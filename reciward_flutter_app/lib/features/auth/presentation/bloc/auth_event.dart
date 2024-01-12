// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final UserEntity userEntity;

  const AuthLoginRequested({required this.userEntity});
}

class AuthLogoutRequested extends AuthEvent {
  final String accessToken;
  const AuthLogoutRequested({
    required this.accessToken,
  });
}

class AuthSignupRequested extends AuthEvent {
  final UserEntity userEntity;

  const AuthSignupRequested({required this.userEntity});

  AuthException? validate() {

    if (userEntity.aprendizEntity == null) {
      return AuthException(errorMessage: 'Not a valid user');
    }

    if (userEntity.password!.length < 6) {
      return AuthException(
          errorMessage: 'Password cannot be less than 6 characters');
    }

    if (userEntity.name == null) {
      return AuthException(errorMessage: 'Name required');
    }

    return null;
  }
}

class UpdatedUser extends AuthEvent {
  final UpdatedUserData userData;
  final bool updatePassword;
  final String accessToken;

  const UpdatedUser({required this.userData, required this.updatePassword, required this.accessToken});

  AuthException? validate() {

    if (updatePassword && (userData.password!.length<6 || userData.oldPassword!.length<6)) {
      return AuthException(
        errorMessage: 'Password cannot be less than 6 characters');
    }

    if (updatePassword && (userData.password != userData.oldPassword)) {
      return AuthException(
        errorMessage: 'Password dont match');
    }

    if (userData.apellido == null) {
      return AuthException(errorMessage: 'Apellido required');
    }

    if (userData.name == null) {
      return AuthException(errorMessage: 'Name required');
    }

    if (userData.email == null) {
      return AuthException(errorMessage: 'Email required');
    }

    return null;
  }
}