class Note {
  int _id;
  String _title;
  String _description;
  String _date;
  int _categoryId;

  Note(this._title, this._description, this._date, this._categoryId);

  Note.withId(
      this._id, this._title, this._description, this._date, this._categoryId);

  int get id => _id;

  String get title => _title;

  set title(String value) {
    if (value.length <= 32) {
      _title = value;
    }
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  int get categoryId => _categoryId;

  set categoryId(int value) {
    if (value != null) {
      _categoryId = value;
    }
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['date'] = date;
    map['categoryId'] = _categoryId;

    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _title = map['title'];
    _description = map['description'];
    _date = map['date'];
    _categoryId = map['categoryId'];
  }
}
