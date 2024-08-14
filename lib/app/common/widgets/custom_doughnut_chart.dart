import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CustomDougnutChart extends StatelessWidget {
  final List<MapEntry<String, dynamic>> dataSource;
  final Color Function(MapEntry<String, dynamic>, int) pointColorMapper;
  final List<Color> colorPalette;

  CustomDougnutChart({required this.dataSource, required this.pointColorMapper, required this.colorPalette});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: Get.width,
      height: Get.height * 0.37,
      child: SfCircularChart(
        series: <CircularSeries>[
          DoughnutSeries<MapEntry<String, dynamic>, String>(
            dataSource: dataSource,
            xValueMapper: (MapEntry<String, dynamic> entry, _) => entry.key,
            yValueMapper: (MapEntry<String, dynamic> entry, _) => parseDouble(entry.value),
            dataLabelMapper: (MapEntry<String, dynamic> entry, _) => '${entry.value}',
            enableTooltip: true,
            selectionBehavior: SelectionBehavior(enable: true),
            explode: true,
            // explodeIndex: 2,
            pointColorMapper: pointColorMapper,
            explodeOffset: '10%',
            radius: '95%',
            // dataLabelSettings: DataLabelSettings(
            //   isVisible: true,
            //   labelPosition: ChartDataLabelPosition.inside,
            //   connectorLineSettings: ConnectorLineSettings(
            //     type: ConnectorType.line,
            //   ),
            //   labelAlignment: ChartDataLabelAlignment.middle,
            // ),
          ),
        ],
        legend: Legend(
          isVisible: true,
          position: LegendPosition.right,
          isResponsive: true,
          toggleSeriesVisibility: false,
          legendItemBuilder: (String name, dynamic series, dynamic point, int index) {
            return Container(
              width: 110,
              // height: 30,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorPalette[index],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "$name ",
                      style: CustomTextStyle.semiBold(14),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    (point.y.toInt()).toString(),
                    style: CustomTextStyle.bold(14),
                  ),
                ],
              ),
            );
          },
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
      ),
    );
  }
}

double parseDouble(dynamic value) {
  if (value != null) {
    try {
      return double.parse(value.toString());
    } catch (e) {
      print("Error parsing double: $e");
    }
  }
  return 0.0;
}
