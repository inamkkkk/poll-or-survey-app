import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:poll_app/providers/poll_provider.dart';
import 'package:poll_app/models/poll.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PollDetailsScreen extends StatelessWidget {
  final int pollId;

  PollDetailsScreen({required this.pollId});

  @override
  Widget build(BuildContext context) {
    final pollProvider = Provider.of<PollProvider>(context);
    final poll = pollProvider.getPoll(pollId);

    if (poll == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Poll Details')),
        body: Center(child: Text('Poll not found.')),
      );
    }

    List<charts.Series<dynamic, String>> _createChartData(Poll poll) {
      final data = poll.votes.entries.map((entry) {
        return _PollData(entry.key, entry.value);
      }).toList();

      return [
        charts.Series<
            _PollData,
            String>(
          id: 'Poll Results',
          domainFn: (_PollData pollData, _) => pollData.option,
          measureFn: (_PollData pollData, _) => pollData.votes,
          data: data,
          labelAccessorFn: (_PollData row, _) => '${row.option}: ${row.votes}',
        ),
      ];
    }

    return Scaffold(
      appBar: AppBar(title: Text('Poll Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Title: ${poll.title}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Options:', style: TextStyle(fontSize: 16)),
            for (var option in poll.options)
              ListTile(
                title: Text(option),
                trailing: Text('${poll.votes[option] ?? 0} votes'),
              ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _showVoteDialog(context, poll);
              },
              child: Text('Vote'),
            ),
            SizedBox(height: 24),
            Expanded(
              child: charts.BarChart(
                _createChartData(poll),
                animate: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showVoteDialog(BuildContext context, Poll poll) {
    String? selectedOption;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Vote for: ${poll.title}'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: poll.options.map((option) {
                  return RadioListTile(
                    title: Text(option),
                    value: option,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value as String?;
                      });
                    },
                  );
                }).toList(),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Vote'),
              onPressed: () {
                if (selectedOption != null) {
                  Provider.of<PollProvider>(context, listen: false).vote(poll.id!, selectedOption);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class _PollData {
  final String option;
  final int votes;

  _PollData(this.option, this.votes);
}