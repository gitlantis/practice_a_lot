import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:practicealot/models/equation.dart';

class EquationDetails extends StatefulWidget {
  final Equation equation;
  EquationDetails(this.equation);
  @override
  State<StatefulWidget> createState() {
    return EquationDetailsState(this.equation);
  }
}

class EquationDetailsState extends State<EquationDetails> {
  Equation equation;
  EquationDetailsState(this.equation);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Details',
            //style: TextStyle(fontSize: 20.0),
          ),
        ),
        body: ListView(padding: EdgeInsets.zero, children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.deepOrange, width: 1.5),
                borderRadius: BorderRadius.circular(4.0)),
            elevation: 4.0,
            child: TeXView(
              teXHTML: equation.equation,
              //r'''<p><strong>Solution:</strong> $$\log_6 x=36^{\log_6 x}=6^3x=6^3$$</p><p><strong>Answer:</strong> 216</p>''',
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.deepPurple, width: 1.5),
                borderRadius: BorderRadius.circular(4.0)),
            elevation: 4.0,
            child: TeXView(teXHTML: equation.solution),
          ),
        ]));
  }
}
