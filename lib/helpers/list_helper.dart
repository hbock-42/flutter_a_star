List<List<int>> squareArray(List<List<int>> source) {
  int rows = source.length;
  int cols = source.first.length;
  int loops = rows > cols ? rows : cols;
  var square =
      List<List<int>>.generate(loops, (i) => List<int>.filled(loops, 0));
  for (var i = 0; i < loops; i++) {
    for (var j = 0; j < loops; j++) {
      try {
        square[i][j] = source[i][j];
      } catch (ex) {
        square[i][j] = 0;
      }
    }
  }
  return square;
}
