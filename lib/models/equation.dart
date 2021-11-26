class Equation {
  int _id;
  int _cathId;
  String _equation;
  String _solution;
  int _isSolved;

  Equation(this._cathId, this._equation, this._solution, this._isSolved);
  Equation.withId(
      this._id, this._cathId, this._equation, this._solution, this._isSolved);

  int get id => _id;
  int get cathId => _cathId;
  String get equation => _equation;
  String get solution => _solution;
  int get isSolved => _isSolved;

  set cathId(int newCathId) {
    this._cathId = newCathId;
  }

  set equation(String newEquation) {
    this._equation = newEquation;
  }

  set solution(String newSolution) {
    this._solution = newSolution;
  }

  set isSolved(int newSolved) {
    this._isSolved = newSolved;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }

    map['cath_id'] = cathId;
    map['equation_title'] = equation;
    map['equation_content'] = solution;
    map['is_solved'] = isSolved;

    return map;
  }

  Equation.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._cathId = map['cath_id'];
    this._equation = map['equation_title'];
    this._solution = map['equation_content'];
    this._isSolved = map['is_solved'];
  }
}
