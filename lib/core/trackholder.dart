class TrackHolder {
  final List<List<int>> _track = [];

  List<List<int>> get track => _track;

  int _index = 0;
  int get index => _index;

  void updateIndex() {
    _index = (_index + 1).remainder(_track.length);
  }

  void addTrack(List<int> freq) {
    _track.add(freq);
  }

  void rmTrack(int index) {
    _track.removeAt(index);
  }

  void moveR(int index) {
    if (index != _track.length - 1) {
      List<int> current = _track[index];
      rmTrack(index);
      _track.insert(index + 1, current);
    }
  }

  void moveL(int index) {
    if (index > 0) {
      List<int> current = _track[index];
      rmTrack(index);
      _track.insert(index - 1, current);
    }
  }

  void incTime(index) {
    _track[index][1] = (_track[index][1] + 50).clamp(0, 2000);
  }

  void decTime(index) {
    _track[index][1] = (_track[index][1] - 50).clamp(0, 2000);
  }
}
