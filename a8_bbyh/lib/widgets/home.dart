import 'package:a8_bbyh/data/visits_repository.dart';
import 'package:a8_bbyh/models/visit.dart';
import 'package:a8_bbyh/widgets/edit_visit.dart';
import 'package:a8_bbyh/widgets/new_visit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title, required this.visitsRepo});

  final String title;
  final IVisitsRepository visitsRepo;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final VisitsRepository _visitsRepo = VisitsRepository.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Visit>>(
              future: _visitsRepo.readVisits(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Visit> visits = snapshot.data!;
                  visits.sort((a, b) => -a.date.compareTo(b.date));

                  return ListView.builder(
                    itemCount: visits.length,
                    itemBuilder: (context, index) {
                      return _buildVisitItem(context, visits[index]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewVisit()),
          );

          if (result == true) {
            setState(() {});
          }
        },
        tooltip: 'New visit',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildVisitItem(BuildContext context, Visit visit) {
    IconData icon;
    Color iconColor;
    String statusText;

    switch (visit.status) {
      case VisitStatus.approved:
        icon = Icons.check_circle;
        iconColor = Colors.green;
        statusText = 'Approved';
        break;
      case VisitStatus.pending:
        icon = Icons.access_time;
        iconColor = Colors.orange;
        statusText = 'Pending';
        break;
      case VisitStatus.rejected:
        icon = Icons.cancel;
        iconColor = Colors.red;
        statusText = 'Rejected';
        break;
    }

    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(statusText),
      subtitle: Text(
          'Date: ${DateFormat.yMMMMEEEEd().format(visit.date.toLocal())}\n${visit.description}'),
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditVisit(visit)),
        );

        if (result == true) {
          setState(() {});
        }
      },
      trailing: GestureDetector(
        onTap: () {
          _showDeleteConfirmationDialog(context, visit);
        },
        child: const Icon(Icons.delete, color: Colors.red),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Visit visit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this visit?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _visitsRepo.deleteVisit(visit);
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
