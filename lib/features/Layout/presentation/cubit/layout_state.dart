part of 'layout_cubit.dart';

 class LayoutState extends Equatable {
  final int currentIndex;

  const LayoutState(this.currentIndex);

  @override
  List<Object> get props => [currentIndex];
}

