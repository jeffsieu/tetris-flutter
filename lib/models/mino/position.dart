class Position {
  const Position(this.x, this.y);

  final int x;
  final int y;

  Position shifted({int x = 0, int y = 0}) {
    return Position(this.x + x, this.y + y);
  }
}
