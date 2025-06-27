import 'package:bizorda/features/auth/data/repos/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../shared/data/models/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {

    final authRepository = AuthRepository();

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.login(nationalID: event.username, password: event.password);
        
        await Future.delayed(const Duration(seconds: 1)); // заглушка
        emit(AuthFailure(message: 'Ошибка входа'));
      } catch (e) {
        emit(AuthFailure(message: 'Ошибка входа'));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      String password = event.password;
      try{
        User user = await authRepository.registerUser(companyId: event.user.companyId,
            fullname: event.user.fullname, nationalId: event.user.nationalId,
            position: event.user.position, password: password);

        await Future.delayed(const Duration(seconds: 1)); // заглушка
        emit(AuthAuthenticated(user: user));
      }catch (e) {
        emit(AuthFailure(message: 'Ошибка Регистрации'));
      }
    }

    );

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(milliseconds: 500)); // заглушка
      emit(AuthInitial());
    });
  }


}

