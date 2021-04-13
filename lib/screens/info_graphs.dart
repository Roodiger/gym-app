import 'package:flutter/material.dart';
import 'package:gym_app/nav_drawer.dart';
import 'package:gym_app/graphs/line_graph.dart';
import 'package:gym_app/graphs/pie_chart.dart';


class InfoGraphPage extends StatelessWidget {

  final tabs = [
    'Exercise Volume',
    'Muscles Worked',
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
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: LineGraph.withSampleData()
                  ),
                  Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: Text("This is a chart depicting your exercise volume.",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                          ),
                  ),

                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: PieChart.withSampleData(),
                  ),
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: Text("This is a chart depicting your muscles worked.",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
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