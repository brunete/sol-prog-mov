import 'package:a8_bbyh/data/visits_repository.dart';
import 'package:a8_bbyh/models/visit.dart';
import 'package:flutter/material.dart';

class NewVisit extends StatelessWidget {
  late DateTime _selectedDate = DateTime.now();
  late final TextEditingController _descriptionController =
      TextEditingController();
  late final VisitsRepository _visitsRepo = VisitsRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("New visit"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Select the date:'),
            SizedBox(
              height: 200,
              child: CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),
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
                Visit visit = Visit.withoutId(
                    status: VisitStatus.pending,
                    date: _selectedDate,
                    description: _descriptionController.text);
                _visitsRepo.createVisit(visit);
                Navigator.pop(context, true);
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
