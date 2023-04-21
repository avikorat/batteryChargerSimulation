import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc/loading/loading_bloc.dart';
import 'package:smart/bloc/loading/loading_event.dart';
import 'package:smart/screen/settings.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

List<String> batteryType = ["AGM", "ATB", "GEL", "Lithium", "WET"];

class _MainScreenState extends State<MainScreen> {
  var voltageList = ['2.47', '2.58', '2.89', '2.00', '0.00'];

// generates a new Random object
  final _random = new Random();
  int indexofType = 0;

  String batteryStatus = "No battery";
  double volatageValue = 0.00;
  double currentValue = 0.00;
  String timeValue = "0:00";

  final List<String> _names = [
    "Battery Capacity",
    "Battery Type",
    "Charging Status",
    "Charging Voltage",
    "Charging Time",
    "Charging Current"
  ];

  double gaugeVal = 0;

  List<double> snapValues = [0, 20, 40, 60, 80, 100];

  double _closestSnapValue(double value) {
    return snapValues.reduce((a, b) {
      var distanceA = (value - a).abs();
      var distanceB = (value - b).abs();
      return distanceA < distanceB ? a : b;
    });
  }

  // Grid tile widget
  Widget _gridTiles(String name, String value) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: Colors.blueAccent,
        shadowColor: Colors.red,
        elevation: 15,
        child: Container(
            height: 60,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.blue, Color.fromARGB(255, 52, 50, 184)]),
            ),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ],
              ),
            ))),
      ),
    );
  }

  Widget _gauge(double data) {
    return Stack(
      children: [
        Center(
          child: Image.asset("assets/companyLogo.png",
              opacity: AlwaysStoppedAnimation(0.2),
              height: 250,
              width: MediaQuery.of(context).size.width / 3),
        ),
        SizedBox(
          height: 250,
          child: SfRadialGauge(
              enableLoadingAnimation: true,
              animationDuration: 4500,
              axes: <RadialAxis>[
                RadialAxis(
                    minimum: 0,
                    maximum: 100,
                    axisLabelStyle: GaugeTextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold),
                    showLastLabel: true,
                    onAxisTapped: (val) {
                      setGaugeVal(val);
                    },
                    ranges: <GaugeRange>[
                      GaugeRange(
                          startValue: 0,
                          endValue: 25,
                          color: Colors.red,
                          startWidth: 10,
                          endWidth: 10),
                      GaugeRange(
                          startValue: 25,
                          endValue: 45,
                          color: Colors.yellow,
                          startWidth: 10,
                          endWidth: 10),
                      GaugeRange(
                          startValue: 45,
                          endValue: 70,
                          color: Colors.orange,
                          startWidth: 10,
                          endWidth: 10),
                      GaugeRange(
                          startValue: 70,
                          endValue: 100,
                          color: Colors.green,
                          startWidth: 10,
                          endWidth: 10)
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(
                        animationType: AnimationType.linear,
                        animationDuration: 2000,
                        value: data,
                        needleColor: Colors.blue,
                        needleLength: 0.6,
                        knobStyle:
                            KnobStyle(color: Colors.blue, knobRadius: 0.05),
                        needleEndWidth: 6,
                      )
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                          widget: Container(
                              child: Text("SOC: ${data.toStringAsFixed(0)}%",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.blue))),
                          angle: 90,
                          positionFactor: 0.7)
                    ])
              ]),
        ),
      ],
    );
  }

 
  setGaugeVal(double valll) {
    gaugeVal = _closestSnapValue(valll);

    print(gaugeVal);
    if (gaugeVal == 0) {
      batteryStatus = "No battery";
      volatageValue = 00.00;
      currentValue = 0.00;
      timeValue = "00:00";
    } else if (gaugeVal == 20) {
      batteryStatus = "Charging";
      volatageValue = 13.3;
      currentValue = 5.00;
      timeValue = "01:00";
    } else if (gaugeVal == 40) {
      batteryStatus = "Charging";
      volatageValue = 13.41;
      currentValue = 5.00;
      timeValue = "02:00";
    } else if (gaugeVal == 60) {
      batteryStatus = "Charging";
      volatageValue = 13.54;
      currentValue = 5.00;
      timeValue = "03:00";
    } else if (gaugeVal == 80) {
      batteryStatus = "Charging";
      volatageValue = 13.62;
      currentValue = 4.50;
      timeValue = "04:00";
    } else if (gaugeVal == 100) {
      gaugeVal = 100;
      batteryStatus = "Charged";
      volatageValue = 14.60;
      currentValue = 0.50;
      timeValue = "05:00";
    }

    Future.delayed(Duration(milliseconds: 500));
    setState(() {});
  }

  _notConnectionWidget() {
    Future.delayed(
      Duration(seconds: 3),
      () {
        context.read<LoadingBloc>().add(Loading(false));
      },
    );
  }

  setChargingStatus(int data) {}

  @override
  void initState() {
    _notConnectionWidget();

    if (selectedValue == "") {
      selectedValue = "Profile-1 AGM";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(96, 228, 227, 227),
        body: BlocBuilder<LoadingBloc, bool>(
          builder: (context, loadingState) {
            if (loadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            int val = batteryMode.indexOf(selectedValue);

            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      _gauge(gaugeVal),
                      const SizedBox(
                        height: 8,
                      ),
                      _gridTiles(
                          _names[1], selectedValue.split(" ").last),
                      const SizedBox(
                        height: 10,
                      ),
                      _gridTiles(_names[2], batteryStatus),
                      const SizedBox(
                        height: 10,
                      ),
                      _gridTiles(_names[3], volatageValue.toString()),
                      const SizedBox(
                        height: 10,
                      ),
                      _gridTiles(_names[4], timeValue),
                      const SizedBox(
                        height: 10,
                      ),
                      _gridTiles(_names[5], "$currentValue Amp"),
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: Image.asset("assets/companyLogo.png"))
                    ],
                  ),
                ));
          },
        ));
  }
}
