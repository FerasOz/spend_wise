import 'package:flutter_bloc/flutter_bloc.dart';

import 'shell_state.dart';

class ShellCubit extends Cubit<ShellState> {
  ShellCubit() : super(const ShellState());

  void changeTab(int index) {
    if (state.currentIndex == index) {
      return;
    }

    emit(state.copyWith(currentIndex: index));
  }
}
