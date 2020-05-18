extension ListExtentions on List<List<int>> {
  List<List<int>> squareArray() {
    int rows = this.length;
    int cols = this.first.length;
    int loops = rows > cols ? rows : cols;
    var square =
        List<List<int>>.generate(loops, (i) => List<int>.filled(loops, 0));
    for (var i = 0; i < loops; i++) {
      for (var j = 0; j < loops; j++) {
        try {
          square[i][j] = this[i][j];
        } catch (ex) {
          square[i][j] = 0;
        }
      }
    }
    return square;
  }
}
