import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart/bloc/loading/loading_bloc.dart';
import 'package:smart/bloc/tab/tab_service_bloc.dart';
import 'package:smart/bloc/tab/tab_service_events.dart';
import 'package:smart/utils/utils.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

String selectedValue = "";
List<String> batteryMode = <String>[
  "Profile-2 ATB",
  'Profile-3 GEL',
  "Profile-4 Lithium",
  "Profile-5 WET",
  'Profile-1 AGM',
];

class _SettingsState extends State<Settings> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedKey;

  Widget _spacing() {
    return const SizedBox(
      height: 16,
    );
  }

  _decoration(String lable) {
    return InputDecoration(
        labelText: lable,
        focusColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6))));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: const Text(
              "Set up",
              style: TextStyle(color: Colors.white),
            )),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: BlocBuilder<LoadingBloc, bool>(
                        builder: (context, state) {
                      return state
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Form(
                              key: _formKey,
                              child: Column(children: [
                                DropdownButtonFormField<String>(
                                  value: selectedValue,
                                  onChanged: (value) {
                                    _selectedKey = value;
                                  },
                                  decoration: _decoration('Select the brand'),
                                  items: batteryMode
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select battery options.';
                                    }
                                    return null;
                                  },
                                ),
                                _spacing(),
                                MaterialButton(
                                    color: Colors.blue,
                                    textColor: Colors.white,
                                    child: Center(
                                        child: Text(
                                      "Save",
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    height: 50,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    onPressed: (() {
                                      if (_formKey.currentState!.validate()) {
                                        selectedValue = _selectedKey!;
                                        DialogBox(
                                          context: context,
                                          Title: "Saving Battery Parameters",
                                          widget: SizedBox(
                                              width: 20,
                                              height: 40,
                                              child:
                                                  CircularProgressIndicator()),
                                        );
                                        setState(() {});

                                        Future.delayed(
                                          Duration(seconds: 3),
                                          () {
                                            Navigator.pop(context);
                                            context
                                                .read<TabServiceBloc>()
                                                .add(UpdateTabList(0));
                                          },
                                        );
                                      }
                                    }))
                              ]));
                    })))));
  }
}
