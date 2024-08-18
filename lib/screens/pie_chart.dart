import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CrimeTypePieChart extends StatefulWidget {
  const CrimeTypePieChart({super.key});

  @override
  State<CrimeTypePieChart> createState() => _CrimeTypePieChartState();
}

class _CrimeTypePieChartState extends State<CrimeTypePieChart> {
  Map<String, double> _data = {};
  Set<String> _selectedCrimeTypes = {};

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('Posts').get();
    final crimeCounts = <String, double>{};

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final crimeType = data['Choose Crime Type'] as String;

      if (crimeCounts.containsKey(crimeType)) {
        crimeCounts[crimeType] = crimeCounts[crimeType]! + 1;
      } else {
        crimeCounts[crimeType] = 1;
      }
    }

    setState(() {
      _data = crimeCounts;
      _selectedCrimeTypes = _data.keys.toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    final donutChartData = _data.entries
        .where((entry) => _selectedCrimeTypes.contains(entry.key))
        .map((entry) {
      return PieChartSectionData(
        value: entry.value,
        color: _getColor(entry.key),
        title: entry.key,
        radius: 100,
        titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
      );
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _data.isEmpty
                  ? const CircularProgressIndicator()
                  : PieChart(
                      PieChartData(
                        sections: donutChartData,
                        centerSpaceRadius: 70,
                        sectionsSpace: 0,
                        startDegreeOffset: 300,
                      ),
                    ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Wrap(
              spacing: 10,
              runSpacing: 5,
              children: _data.keys.map((crimeType) {
                final isSelected = _selectedCrimeTypes.contains(crimeType);
                return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedCrimeTypes.remove(crimeType);
                        } else {
                          _selectedCrimeTypes.add(crimeType);
                        }
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          color: _getColor(crimeType).withOpacity(0.5),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          crimeType,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ));
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor(String crimeType) {
    switch (crimeType) {
      case 'ChooseCrimeType':
        return Colors.red;
      case 'Armed Assault':
        return Colors.blue;
      case 'Assasination':
        return Colors.green;
      case 'Vehicle Theft':
        return Colors.pink;
      case 'Vehicle Stolen':
        return Colors.yellow;
      case 'Drugs':
        return Colors.purple;
      case 'Harassment':
        return Colors.teal;
      case 'Hijacking':
        return Colors.lightBlueAccent;
      case 'Hostage(Kidnapping)':
        return Colors.indigo;
      case 'Mobile Snatching':
        return const Color.fromARGB(255, 95, 99, 63);
      case 'Purse Snatching':
        return const Color.fromARGB(255, 12, 255, 3);
      case 'Murder':
        return const Color.fromARGB(255, 102, 1, 35);
      case 'Robery':
        return const Color.fromARGB(255, 46, 10, 22);
      default:
        return Colors.grey;
    }
  }
}
