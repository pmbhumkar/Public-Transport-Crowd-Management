import 'package:flutter/material.dart';

class SanitizationForm extends StatefulWidget {
  @override
  _SanitizationFormState createState() => _SanitizationFormState();
}

class _SanitizationFormState extends State<SanitizationForm> {
  bool _driver_checked = false;
  bool _conductor_checked = false;
  bool _bus_checked = false;
  String errorMessage = "New Error";

  bool validation() {
    if (_driver_checked && _conductor_checked && _bus_checked) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sanitization Check"),
        backgroundColor: Colors.grey[800],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
        ),
        child: ListView(children: <Widget>[
          Card(
            child: CheckboxListTile(
              title: Text("Driver is healthy"),
              value: _driver_checked,
              onChanged: (newValue) {
                setState(() {
                  _driver_checked = newValue;
                });
              },
              controlAffinity: ListTileControlAffinity.trailing,
              activeColor: Colors.green,
              checkColor: Colors.white,
            ),
          ),
          Card(
            child: CheckboxListTile(
              title: Text("Conductor is healthy"),
              value: _conductor_checked,
              onChanged: (newValue) {
                setState(() {
                  _conductor_checked = newValue;
                });
              },
              controlAffinity: ListTileControlAffinity.trailing,
              activeColor: Colors.green,
              checkColor: Colors.white,
            ),
          ),
          Card(
            child: CheckboxListTile(
              title: Text("Bus is sanitized"),
              value: _bus_checked,
              onChanged: (newValue) {
                setState(() {
                  _bus_checked = newValue;
                });
              },
              controlAffinity: ListTileControlAffinity.trailing,
              activeColor: Colors.green,
              checkColor: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 5),
            child: ButtonTheme(
              height: 50,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
                color: Colors.yellow,
                textColor: Colors.black,
                padding: EdgeInsets.all(8.0),
                onPressed: () {
                  if (validation()) {
                    setState(() {
                      errorMessage = "";
                    });
                  } else {
                    setState(() {
                      errorMessage = "All checkboxes need to be checked";
                    });
                  }
                },
                child: Text(
                  "Submit".toUpperCase(),
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.red, fontSize: 14.0),
            ),
          )
        ]),
      ),
    );
  }
}
