import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  LibraryCubit() : super(LibraryInitial());
}
