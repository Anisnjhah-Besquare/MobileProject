import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends Cubit<String> {
  LoginPage() : super('');

  void textInput(username) => emit(username.toUpperCase());

  void textClear() => emit('');
}
