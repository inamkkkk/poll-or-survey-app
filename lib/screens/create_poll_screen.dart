import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:poll_app/providers/poll_provider.dart';
import 'package:poll_app/models/poll.dart';

class CreatePollScreen extends StatefulWidget {
  @override
  _CreatePollScreenState createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  List<TextEditingController> _optionControllers = [TextEditingController(), TextEditingController()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Poll')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Poll Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text('Options:'),
              for (int i = 0; i < _optionControllers.length; i++) // Use index for dynamic access
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _optionControllers[i],
                    decoration: InputDecoration(labelText: 'Option ${i + 1}'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an option';
                      }
                      return null;
                    },
                  ),
                ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _optionControllers.add(TextEditingController());
                  });
                },
                child: Text('Add Option'),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    List<String> options = _optionControllers.map((controller) => controller.text).toList();
                    Map<String, int> votes = {};
                    for (var option in options) {
                      votes[option] = 0;
                    }

                    Poll newPoll = Poll(
                      title: _titleController.text,
                      options: options,
                      votes: votes,
                    );
                    Provider.of<PollProvider>(context, listen: false).addPoll(newPoll);
                    Navigator.pop(context);
                  }
                },
                child: Text('Create Poll'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}