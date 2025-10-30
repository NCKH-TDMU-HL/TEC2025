import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WaterChart extends StatefulWidget {
  const WaterChart({super.key});

  @override
  State<WaterChart> createState() => _WaterChartState();
}

class _WaterChartState extends State<WaterChart> {
  List<FlSpot> _flowSpots = [];
  List<FlSpot> _totalWaterSpots = [];
  bool _isLoading = true;
  String _errorMessage = '';

  Future<void> _fetchTelemetry() async {
    const url =
        'https://thingsboard.cloud/api/v1/4HsCQd9u2238D8xpptHo/telemetry?keys=flow,totalWater';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        
        // Lấy dữ liệu flow
        if (data.containsKey('flow')) {
          final flowReadings = data['flow'] as List;
          final flowSpots = <FlSpot>[];

          for (int i = 0; i < flowReadings.length; i++) {
            final value = double.tryParse(flowReadings[i]['value'].toString()) ?? 0;
            flowSpots.add(FlSpot(i.toDouble(), value));
          }
          _flowSpots = flowSpots;
        }

        // Lấy dữ liệu totalWater
        if (data.containsKey('totalWater')) {
          final totalWaterReadings = data['totalWater'] as List;
          final totalWaterSpots = <FlSpot>[];

          for (int i = 0; i < totalWaterReadings.length; i++) {
            final value = double.tryParse(totalWaterReadings[i]['value'].toString()) ?? 0;
            totalWaterSpots.add(FlSpot(i.toDouble(), value));
          }
          _totalWaterSpots = totalWaterSpots;
        }

        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Lỗi: ${response.statusCode} - ${response.body}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi kết nối: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTelemetry();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(_errorMessage, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = '';
                });
                _fetchTelemetry();
              },
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (_totalWaterSpots.isEmpty && _flowSpots.isEmpty) {
      return const Center(child: Text('Không có dữ liệu'));
    }

    // Hiển thị biểu đồ totalWater (vì có dữ liệu)
    final spots = _totalWaterSpots.isNotEmpty ? _totalWaterSpots : _flowSpots;
    final title = _totalWaterSpots.isNotEmpty ? 'Tổng lượng nước (L)' : 'Lưu lượng';

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    barWidth: 3,
                    color: Colors.blue,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withValues(alpha: 0.2),
                    ),
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}