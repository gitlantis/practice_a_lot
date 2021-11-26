class Cathegory {
  int _id;
  String _name;

  Cathegory(this._name);
  Cathegory.withId(this._id, this._name);

  int get id => _id;
  String get name => _name;

  set name(String newName) {
    if (newName.length <= 512) {
      this._name = newName;
    }
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['name'] = _name;
    return map;
  }

  Cathegory.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
  }
}
