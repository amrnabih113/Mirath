import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(const LayoutState(0));

  /// Change selected bottom nav index
  void changeTab(int index) {
    if (state.currentIndex == index) return;
    emit(LayoutState(index));
  }

  /// Sync cubit state with GoRouter location
  void syncWithLocation(String location) {
    final index = _locationToIndex(location);
    if (index != state.currentIndex) {
      emit(LayoutState(index));
    }
  }

  /// Map route → tab index
  int _locationToIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/community')) return 1;
    if (location.startsWith('/library')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  } 
}
