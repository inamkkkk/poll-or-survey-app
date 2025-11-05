import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:poll_app/providers/poll_provider.dart';
import 'package:poll_app/screens/create_poll_screen.dart';
import 'package:poll_app/screens/poll_details_screen.dart';

class PollListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pollProvider = Provider.of<PollProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Polls')),
      body: ListView.builder(
        itemCount: pollProvider.polls.length,
        itemBuilder: (context, index) {
          final poll = pollProvider.polls[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(poll.title),
              subtitle: Text('Options: ${poll.options.join(', ')}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PollDetailsScreen(pollId: poll.id!),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePollScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}