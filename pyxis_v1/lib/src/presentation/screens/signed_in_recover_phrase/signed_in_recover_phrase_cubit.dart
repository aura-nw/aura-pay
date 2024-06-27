import 'package:flutter_bloc/flutter_bloc.dart';

class SignedInRecoverPhraseCubit extends Cubit<bool>{
  SignedInRecoverPhraseCubit() : super(false);

  void onShowPassPhrase(){
    emit(true);
  }
}