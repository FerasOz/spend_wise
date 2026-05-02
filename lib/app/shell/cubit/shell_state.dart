class ShellState {
  const ShellState({
    this.currentIndex = 0,
  });

  final int currentIndex;

  ShellState copyWith({
    int? currentIndex,
  }) {
    return ShellState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}
