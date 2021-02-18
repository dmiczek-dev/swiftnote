class Category {
  int _id;
  String _name;

  Category(this._name);
  Category.withId(this._id, this._name);

  String get name => _name;

  set name(String value) {
    if (value.length <= 32) {
      _name = value;
    }
  }

  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
  }

  Category.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _name = map['name'];
  }
}
