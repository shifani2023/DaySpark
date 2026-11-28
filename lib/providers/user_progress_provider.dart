import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProgressProvider extends ChangeNotifier {
  int _xp = 0;
  String _userName = 'Detective';
  List<String> _unlockedClues = [];
  List<String> _solvedPuzzles = [];
  List<String> _completedMysteries = [];

  int get xp => _xp;
  String get userName => _userName;
  List<String> get unlockedClues => _unlockedClues;
  List<String> get solvedPuzzles => _solvedPuzzles;
  List<String> get completedMysteries => _completedMysteries;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser?.uid ?? 'guest';

  String _resolveFallbackName() {
    final user = _auth.currentUser;

    if (user?.displayName != null &&
        user!.displayName!.trim().isNotEmpty) {
      return user.displayName!.trim();
    }

    if (user?.email != null && user!.email!.contains('@')) {
      return user.email!.split('@').first;
    }

    return 'Detective';
  }

  void clearInMemory() {
    _xp = 0;
    _userName = 'Detective';
    _unlockedClues = [];
    _solvedPuzzles = [];
    _completedMysteries = [];
    notifyListeners();
  }

  Future<void> loadProgress() async {
    final user = _auth.currentUser;

    if (user == null) {
      clearInMemory();
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    _xp = prefs.getInt('xp_$_uid') ?? 0;

    // Name priority:
    // 1. User's manually typed/saved full name
    // 2. Firebase Auth display name
    // 3. Email prefix / Detective fallback
    final savedName = (prefs.getString('name_$_uid') ?? '').trim();
    final authDisplayName = (user.displayName ?? '').trim();

    if (savedName.isNotEmpty) {
      _userName = savedName;
    } else if (authDisplayName.isNotEmpty) {
      _userName = authDisplayName;
    } else {
      _userName = _resolveFallbackName();
    }

    _unlockedClues = prefs.getStringList('clues_$_uid') ?? [];
    _solvedPuzzles = prefs.getStringList('puzzles_$_uid') ?? [];
    _completedMysteries = prefs.getStringList('mysteries_$_uid') ?? [];

    notifyListeners();

    try {
      final doc = await _firestore.collection('users').doc(_uid).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;

        _xp = data['xp'] ?? 0;

        // Only use the cloud name if there is no locally saved typed name.
        final cloudName = (data['name'] ?? '').toString().trim();

        if (savedName.isNotEmpty) {
          _userName = savedName;
        } else if (cloudName.isNotEmpty) {
          _userName = cloudName;
        }

        _unlockedClues =
            List<String>.from(data['unlockedClues'] ?? []);

        _solvedPuzzles =
            List<String>.from(data['solvedPuzzles'] ?? []);

        _completedMysteries =
            List<String>.from(data['completedMysteries'] ?? []);

        await _saveLocally();

        notifyListeners();
      } else {
        // Brand new user record initialized at 0 XP.
        await _syncToCloud();
      }
    } catch (_) {
      // Continue using locally saved progress if cloud loading fails.
    }
  }

  Future<void> saveUserName(String name) async {
    final clean = name.trim();

    if (clean.isEmpty) return;

    _userName = clean;

    await _saveLocally();

    notifyListeners();

    await _syncToCloud();
  }

  Future<bool> awardXp(
    int amount, {
    String? clueId,
    String? puzzleId,
    String? mysteryId,
  }) async {
    if (clueId != null && _unlockedClues.contains(clueId)) {
      return false;
    }

    if (puzzleId != null && _solvedPuzzles.contains(puzzleId)) {
      return false;
    }

    if (mysteryId != null && _completedMysteries.contains(mysteryId)) {
      return false;
    }

    _xp += amount;

    if (clueId != null) {
      _unlockedClues.add(clueId);
    }

    if (puzzleId != null) {
      _solvedPuzzles.add(puzzleId);
    }

    if (mysteryId != null) {
      _completedMysteries.add(mysteryId);
    }

    await _saveLocally();

    notifyListeners();

    await _syncToCloud();

    return true;
  }

  Future<void> resetCaseClues(String prefix) async {
    _unlockedClues.removeWhere((c) => c.startsWith(prefix));

    await _saveLocally();

    notifyListeners();

    await _syncToCloud();
  }

  Future<void> _saveLocally() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('xp_$_uid', _xp);
    await prefs.setString('name_$_uid', _userName);
    await prefs.setStringList('clues_$_uid', _unlockedClues);
    await prefs.setStringList('puzzles_$_uid', _solvedPuzzles);
    await prefs.setStringList('mysteries_$_uid', _completedMysteries);
  }

  Future<void> _syncToCloud() async {
    final user = _auth.currentUser;

    if (user == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).set(
        {
          'userId': user.uid,
          'email': user.email ?? '',
          'name': _userName,
          'xp': _xp,
          'unlockedClues': _unlockedClues,
          'solvedPuzzles': _solvedPuzzles,
          'completedMysteries': _completedMysteries,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (_) {
      // Ignore cloud synchronization errors.
    }
  }
}