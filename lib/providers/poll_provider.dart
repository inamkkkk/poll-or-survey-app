import 'package:flutter/material.dart';
import 'package:poll_app/models/poll.dart';
import 'package:poll_app/services/database_service.dart';

class PollProvider extends ChangeNotifier {
  List<Poll> _polls = [];
  final _databaseService = DatabaseService.instance;

  PollProvider() {
    _loadPolls();
  }

  List<Poll> get polls => _polls;

  Future<void> _loadPolls() async {
    _polls = await _databaseService.getPolls();
    notifyListeners();
  }

  Future<void> addPoll(Poll poll) async {
    int id = await _databaseService.insertPoll(poll);
    _polls.add(poll.copyWith(id: id));
    notifyListeners();
  }

  Poll? getPoll(int id) {
    try{
      return _polls.firstWhere((poll) => poll.id == id);
    } catch(e) {
      return null;
    }
  }

  Future<void> vote(int pollId, String option) async {
    final pollIndex = _polls.indexWhere((poll) => poll.id == pollId);
    if (pollIndex != -1) {
      final poll = _polls[pollIndex];
      final votes = Map<String, int>.from(poll.votes);
      votes[option] = (votes[option] ?? 0) + 1;
      final updatedPoll = poll.copyWith(votes: votes);

      await _databaseService.updatePoll(updatedPoll);

      _polls[pollIndex] = updatedPoll;
      notifyListeners();
    }
  }

  Future<void> deletePoll(int id) async {
    await _databaseService.deletePoll(id);
    _polls.removeWhere((poll) => poll.id == id);
    notifyListeners();
  }
}