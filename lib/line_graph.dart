import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class LineGraph extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  LineGraph(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory LineGraph.withSampleData() {
    return new LineGraph(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(seriesList, animate: animate,   domainAxis: new charts.NumericAxisSpec (
        renderSpec: new charts.SmallTickRendererSpec(

          // Tick and Label styling here.
            labelStyle: new charts.TextStyleSpec(
                fontSize: 14, // size in Pts.
                color: charts.MaterialPalette.white),

            // Change the line colors to match text color.
            lineStyle: new charts.LineStyleSpec(
                color: charts.MaterialPalette.white))),

      /// Assign a custom style for the measure axis.
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.GridlineRendererSpec(

            // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 14, // size in Pts.
                  color: charts.MaterialPalette.white),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.white))),);
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      new LinearSales(0, 5),
      new LinearSales(1, 25),
      new LinearSales(2, 60),
      new LinearSales(3, 75),
      new LinearSales(4, 25),
      new LinearSales(5, 100),
      new LinearSales(6, 95),
      new LinearSales(7, 60),
      new LinearSales(8, 75),


    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}

