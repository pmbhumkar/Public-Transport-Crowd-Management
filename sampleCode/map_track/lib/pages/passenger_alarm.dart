import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:maptrack/services/database.dart';

class SafetyViolationAlarm extends StatefulWidget {
  @override
  _SafetyViolationAlarmState createState() => _SafetyViolationAlarmState();
}

class _SafetyViolationAlarmState extends State<SafetyViolationAlarm> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  List<String> routes = [];
  bool once = false;
  DatabaseService d = DatabaseService();

  initRouteList() async {
    List<String> tempRoutes = [];
    setState(() {
      routes = [];
    });

    tempRoutes = await d.getBusRoutes();
    setState(() {
      routes = tempRoutes;
      once = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (once == false) {
      initRouteList();
    }
    return Scaffold(
        appBar: AppBar(title: Text('Health Safety Alarm'),  
        backgroundColor:Colors.grey[800]),
        body: FormBuilder(
          key: _fbKey,
          initialValue: {
            'date': DateTime.now(),
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                //* ----------------------------------------------------
                //* Input widgets
                //* ----------------------------------------------------
                _dateTimePicker(),
                _buildRouteSelectionDropDown(),
                _buildDefaulterCheckboxWidgets(),
                _buildProtocolViolatedCheckboxWidgets(),
                _buildSanitizationViolatedCheckboxWidgets(),
                //_buildChipsWidgets(),
                //_buildPickerWidgets(),
                //_buildSliderWidgets(),
                //_buildRadioDropdownAndSwitchWidgets(),
                //_buildTextInputWidgets(context),
                //_buildOtherWidgets(),
                //* ----------------------------------------------------
                //* Form buttons
                //* ----------------------------------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        child: Text('Submit'),
                        onPressed: () {
                          if (_fbKey.currentState.saveAndValidate()) {
                            final formInputs = _fbKey.currentState.value;
                            print(formInputs);
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: Text("Form inputs"),
                                      content: Text("$formInputs"),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Close'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    ));
                          }
                        },
                      ),
                      RaisedButton(
                        child: Text('Reset'),
                        onPressed: () {
                          _fbKey.currentState.reset();
                         },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget _buildDefaulterCheckboxWidgets() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FormBuilderCheckboxGroup(
                attribute: 'checkboxGroup',
                decoration: InputDecoration(labelText: "Choose defaulter"),
                options: [
                  FormBuilderFieldOption(value: "Co-passenger"),
                  FormBuilderFieldOption(value: "Driver"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProtocolViolatedCheckboxWidgets() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FormBuilderCheckboxGroup(
                attribute: 'checkboxGroup',
                decoration: InputDecoration(
                    labelText: "Choose safety protocol violated"),
                options: [
                  FormBuilderFieldOption(value: "Mask"),
                  FormBuilderFieldOption(value: "Social distancing"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSanitizationViolatedCheckboxWidgets() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
             FormBuilderCheckboxGroup(
                attribute: 'checkboxGroup',
                decoration: InputDecoration(
                    labelText: "Is this vehicle sanitized"),
                options: [
                  FormBuilderFieldOption(value: "Yes"),
                  FormBuilderFieldOption(value: "No"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRouteSelectionDropDown() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text('Select route',
                  style: TextStyle(fontSize: 20, color: Colors.black)),
              FormBuilderDropdown(
                hint: Text('Select route from dropdown'),
                attribute: 'dropdown',
                items: routes
                    .map((route) =>
                        DropdownMenuItem(value: route, child: Text("$route")))
                    .toList(),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateTimePicker() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FormBuilderDateTimePicker(
                attribute: "dateTime",
                inputType: InputType.both,
                format: DateFormat("yyyy-MM-dd HH:mm"),
                decoration:
                    InputDecoration(labelText: "Pick ride date and time"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
