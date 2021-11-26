import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:practicealot/models/cathegory.dart';
import 'package:practicealot/models/equation.dart';
import 'package:practicealot/screens/equation_detailes.dart';
import 'package:practicealot/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class EquationList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EquationListState();
  }
}

class EquationListState extends State<EquationList> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Cathegory> cathegoryList;
  List<Equation> equationList;
  int countEq = 0;
  int countCath = 0;
  int tapped = 4;

  @override
  Widget build(BuildContext context) {
    if (cathegoryList == null) {
      cathegoryList = List<Cathegory>();
      equationList = List<Equation>();
      _updateListViews();
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text(
        'φracticealot',
        style: TextStyle(fontSize: 30.0),
      )),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 170.0,
              child: DrawerHeader(
                child: Text(
                  'φ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 100.0,
                    shadows: [
                      Shadow(
                        blurRadius: 50.0,
                        color: Colors.black,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 170.0,
              child: _getCathegoryList(),
            )
          ],
        ),
      ),
      body: getEquations(tapped),
    );
  }

  ListView _getCathegoryList() {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black26, width: 1),
              borderRadius: BorderRadius.circular(2.0)),
          color: Colors.white,
          elevation: 1.0,
          child: ListTile(
            title: Text(
              cathegoryList[index].name,
              style: textStyle.apply(
                color: Colors.deepPurple,
                fontSizeDelta: -1.0,
              ),
            ),
            onTap: () {
              _scaffoldKey.currentState.openEndDrawer();
              this.tapped = cathegoryList[index].id;
              //getEquations(cathegoryList[index].id);
              _updateListViews();
            },
          ),
        );
      },
      itemCount: countCath,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
    );
  }

  ListView getEquations(int cathId) {
    print('tapped $cathId');
    return ListView.builder(
      itemCount: countEq,
      itemBuilder: (BuildContext context, int index) {
        var isSolved = equationList[index].isSolved;
        return Card(
          shape: isSolved == 1
              ? RoundedRectangleBorder(
                  side: BorderSide(color: Colors.deepPurple, width: 1.5),
                  borderRadius: BorderRadius.circular(4.0))
              : RoundedRectangleBorder(
                  side: BorderSide(color: Colors.deepOrange, width: 1.5),
                  borderRadius: BorderRadius.circular(4.0)),
          //color: Colors.deepOrange,
          elevation: 4.0,
          child: ListTile(
            leading: Text((index + 1).toString(),
                style: TextStyle(fontSize: 23.0, color: Colors.black38)),
            title: TeXView(
              teXHTML: equationList[index].equation,
            ),
            trailing: InkWell(
              child: CircleAvatar(
                foregroundColor: Colors.deepOrange,
                backgroundColor: Colors.black12,
                child: Icon(
                  Icons.arrow_forward,
                  color: isSolved == 1 ? Colors.deepPurple : Colors.deepOrange,
                ),
              ),
              onTap: () => _toEquationDetails(equationList[index]),
            ),
          ),
        );
      },
    );
  }

  void _updateListViews() {
    equationList = null;

    final Future<Database> dbFuture = databaseHelper.initalizeDatabase();

    dbFuture.then((database) {
      if (equationList == null) {
        Future<List<Cathegory>> cathegoryListFuture =
            databaseHelper.getCathegory();
        cathegoryListFuture.then((cathList) {
          setState(() {
            this.cathegoryList = cathList;
            this.countCath = cathList.length;
          });
        });
      }

      Future<List<Equation>> equationListFuture =
          databaseHelper.getEquation(tapped);
      equationListFuture.then((eqList) {
        setState(() {
          this.equationList = eqList;
          this.countEq = eqList.length;
        });
      });
    });
  }

  void _toEquationDetails(Equation equation) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EquationDetails(equation);
    }));
  }
}
