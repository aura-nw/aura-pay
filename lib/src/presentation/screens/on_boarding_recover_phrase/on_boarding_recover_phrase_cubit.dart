import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoardingRecoverPhraseCubit extends Cubit<bool>{
  OnBoardingRecoverPhraseCubit() : super(false);

  void onShowPassPhrase(){
    emit(true);
  }
}