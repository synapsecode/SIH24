import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DustbinDistanceFilterWidget extends StatelessWidget {
  final TextEditingController radiusController;
  final Function(double?) onRadiusSelected;
  const DustbinDistanceFilterWidget({
    Key? key,
    required this.onRadiusSelected,
    required this.radiusController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.social_distance),
      onPressed: () {
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Distance Filter'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: radiusController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      label: Text(
                        'Distance (km)',
                        style: TextStyle(color: Colors.black45),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final d = radiusController.value.text;
                      if (d.isEmpty) {
                        onRadiusSelected(null);
                      } else {
                        final radius = double.tryParse(d);
                        onRadiusSelected(radius);
                      }
                    },
                    child: const Text('Search'),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class DustbinTypeFilterWidget extends StatelessWidget {
  final Function(String) onFilterSelected;
  DustbinTypeFilterWidget({Key? key, required this.onFilterSelected})
      : super(key: key);

  final dustbinConfigs = [
    {'label': 'MAMT', 'color': Colors.blue},
    {'label': 'Non-Biodegradable', 'color': Colors.red},
    {'label': 'Biodegradable', 'color': Colors.green},
    {'label': 'Hazardous', 'color': Colors.orange},
    {'label': 'E-Waste', 'color': Colors.yellow},
    {'label': 'Recyclable', 'color': Colors.cyan},
    {'label': 'ALL', 'color': Colors.black},
  ];

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.menu),
      onPressed: () {
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Filter Dustbins'),
              content: SizedBox(
                height: 350,
                child: Column(
                  children: [
                    for (final i in dustbinConfigs)
                      ElevatedButton(
                        onPressed: () {
                          onFilterSelected(i['label'] as String);
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromWidth(300),
                          backgroundColor: i['color'] as Color,
                        ),
                        child: Text(i['label'] as String),
                      )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
