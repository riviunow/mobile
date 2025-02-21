import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rvnow/features/auth/services/jwt_service.dart';
import 'package:rvnow/features/profile/models/update_profile.dart';
import 'package:rvnow/features/profile/services/profile_service.dart';
import 'package:rvnow/shared/models/index.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {
  final User? user;

  LoadProfile({this.user});
}

class UpdateProfile extends ProfileEvent {
  final UpdateProfileRequest request;

  UpdateProfile(this.request);
}

class DeleteAccount extends ProfileEvent {}

class RemoveProfile extends ProfileEvent {}

abstract class ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;

  ProfileLoaded(this.user);
}

class ProfileUpdated extends ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileError extends ProfileState {
  final List<String> messages;
  final Map<String, List<String>> fieldErrors;

  ProfileError({this.messages = const [], this.fieldErrors = const {}});
}

class ProfileDeleted extends ProfileState {}

class UnauthenticatedProfile extends ProfileState {}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileService profileService;
  final JwtService jwtService;

  ProfileBloc(this.profileService, this.jwtService) : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      if (event.user != null) {
        emit(ProfileLoaded(event.user!));
        return;
      }
      var response = await profileService.getUser();
      await response.on(
          onFailure: (errors, fieldErrors) {
            emit(UnauthenticatedProfile());
            jwtService.removeAccessToken();
            jwtService.removeRefreshToken();
          },
          onSuccess: (data) => emit(ProfileLoaded(data)));
    });

    on<UpdateProfile>((event, emit) async {
      emit(ProfileLoading());
      var response = await profileService.updateProfile(event.request);
      await response.on(onFailure: (errors, fieldErrors) {
        emit(ProfileError(messages: errors, fieldErrors: fieldErrors));
      }, onSuccess: (data) {
        emit(ProfileUpdated());
        sleep(const Duration(seconds: 1));
        emit(ProfileLoaded(data));
      });
    });

    on<DeleteAccount>((event, emit) async {
      emit(ProfileLoading());
      var response = await profileService.deleteAccount();
      await response.on(onFailure: (errors, _) {
        emit(ProfileError(messages: errors));
      }, onSuccess: (_) {
        jwtService.removeAccessToken();
        jwtService.removeRefreshToken();
        emit(ProfileDeleted());
      });
    });

    on<RemoveProfile>((event, emit) async {
      emit(UnauthenticatedProfile());
    });
  }
}
