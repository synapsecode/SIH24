import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toast/toast.dart';
import 'package:trashtag/backend/TrashTagBackend.dart';

class AddDustbinDialog extends StatefulWidget {
  final LatLng currentLocation;

  const AddDustbinDialog({super.key, required this.currentLocation});
  @override
  _AddDustbinDialogState createState() => _AddDustbinDialogState();
}

class _AddDustbinDialogState extends State<AddDustbinDialog> {
  String selectedType = "";
  final TextEditingController dustbinNameController = TextEditingController();
  final _trBackend = TrashTagBackend();
  void addDustbin() async {
    if (selectedType != "") {
      selectedType = 'General';
    }
    if (dustbinNameController.text.isEmpty) {
      ToastContext().init(context);
      Toast.show('Enter name');
    } else {
      print('object');
      final response = await _trBackend.addDustbin(
          name: dustbinNameController.text,
          location: widget.currentLocation,
          type: selectedType);
      if (response.result == true) {
        Navigator.pop(context);
        Toast.show(response.message);
      } else {
        Toast.show("Couldn't Add dustbin");
      }
    }
  }

  final List<String> dustbinTypes = [
    'QRBIN',
    'Biodegradable',
    'Non-Biodegradable',
    'Recyclable',
    'E-Waste',
    'Hazardous',
    'General'
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: Color.fromARGB(255, 27, 27, 27),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tag Dustbin',
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            TextField(
              controller: dustbinNameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.greenAccent),
                filled: true,
                fillColor: Colors.black54,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Select Dustbin Type',
              style: TextStyle(color: Colors.greenAccent, fontSize: 18),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: dustbinTypes.map((type) {
                return ChoiceChip(
                  label: Text(
                    type,
                    style: TextStyle(
                      color: selectedType == type
                          ? Colors.black
                          : Colors.greenAccent,
                    ),
                  ),
                  selected: selectedType == type,
                  selectedColor: Colors.greenAccent,
                  backgroundColor: Colors.black54,
                  onSelected: (bool selected) {
                    setState(() {
                      selectedType = selected ? type : '';
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'Upload Bin',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              onPressed: () {
                if (dustbinNameController.text.isNotEmpty &&
                    selectedType.isNotEmpty) {
                  final payload = {
                    'name': dustbinNameController.text,
                    'type': selectedType,
                    'location': {
                      'lat': widget.currentLocation.latitude,
                      'lng': widget.currentLocation.longitude,
                    }
                  };
                  addDustbin();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Please enter Dustbin Name and select a Type',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.redAccent,
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void upload(Map payload) async {
    //TOOD: Upload new bin to backend
  }
}
