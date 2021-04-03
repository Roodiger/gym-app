import 'package:flutter/material.dart';
import 'package:gym_app/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_app/nav_drawer.dart';
import 'package:gym_app/line_graph.dart';
import 'package:gym_app/pie_chart.dart';


class InfoGraphPage extends StatelessWidget {

  final tabs = [
    'Muscles Worked',
    'Exercise Volume',
    'Other Graph',
  ];

  @override

  Widget build(BuildContext context) {

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Info Graphs'),
        bottom: TabBar(
          indicatorColor: Colors.white,
          isScrollable: true,
          tabs: [
            for (final tab in tabs) Tab(text: tab),
          ],
        ),
      ),

      body: SafeArea(
        child: Center(
          child: TabBarView(
            children: <Widget>[
              Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: LineGraph.withSampleData()
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                width: MediaQuery.of(context).size.width * 0.90,
                child: PieChart.withSampleData(),
              ),
              Container(
                child: PieChart.withSampleData(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}