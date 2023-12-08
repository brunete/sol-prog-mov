import 'package:a8_bbyh/data/visits_repository.dart';
import 'package:a8_bbyh/models/visit.dart';
import 'package:flutter/material.dart';

class EditVisit extends StatelessWidget {
  late final Visit _visit;
  late final TextEditingController _descriptionController =
      TextEditingController();

  late DateTime _selectedDate = DateTime.now();

  late final VisitsRepository _visitsRepository = VisitsRepository();

  EditVisit(Visit visit, {super.key}) {
    _visit = visit;
    _descriptionController.text = visit.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Edit visit"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Select the date:'),
            SizedBox(
              height: 200,
              child: CalendarDatePicker(
                initialDate: _visit.date,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 30)),
                onDateChanged: (DateTime value) {
                  _selectedDate = value;
                },
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Visit newVisit = Visit.withId(
                    id: _visit.id,
                    status: _visit.status,
                    date: _selectedDate,
                    description: _descriptionController.text);

                _visitsRepository.updateVisit(newVisit);

                Navigator.pop(context, true);
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }

  void updateVisit() {
    _visit.date = _selectedDate;
    _visit.description = _descriptionController.text;
  }
}
