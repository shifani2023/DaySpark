import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/journal_entry.dart';

typedef JsonMap = Map<String, dynamic>;

class JournalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get currentUserId => _auth.currentUser?.uid ?? 'guest';
  String get _storageKey => 'dayspark_casebook_$currentUserId';

  Future<bool> isOnline() async {
    final results = await Connectivity().checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  CollectionReference<JsonMap>? get _userJournalRef {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    return _firestore.collection('users').doc(uid).collection('journal_entries');
  }

  Future<List<JournalEntry>> getEntries() async {
    final localEntries = await _getLocalEntries();

    if (await isOnline() && _userJournalRef != null) {
      try {
        for (final entry in localEntries) {
          await _userJournalRef!.doc(entry.id).set(entry.toJson());
        }
        final snapshot = await _userJournalRef!
            .where('userId', isEqualTo: currentUserId)
            .get();
        final remoteEntries = snapshot.docs
            .map((doc) => JournalEntry.fromJson(doc.data()))
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));
        await _saveLocalEntries(remoteEntries);
        return remoteEntries;
      } catch (_) {
        return localEntries;
      }
    }
    return localEntries;
  }

  Future<void> addEntry(JournalEntry entry) async {
    final entries = await _getLocalEntries();
    entries.insert(0, entry);
    await _saveLocalEntries(entries);

    if (await isOnline() && _userJournalRef != null) {
      try {
        await _userJournalRef!.doc(entry.id).set(entry.toJson());
      } catch (_) {}
    }
  }

  Future<void> updateEntry(JournalEntry updatedEntry) async {
    final entries = await _getLocalEntries();
    final index = entries.indexWhere((e) => e.id == updatedEntry.id);
    if (index != -1) {
      entries[index] = updatedEntry;
      await _saveLocalEntries(entries);
    }

    if (await isOnline() && _userJournalRef != null) {
      try {
        await _userJournalRef!.doc(updatedEntry.id).update(updatedEntry.toJson());
      } catch (_) {}
    }
  }

  Future<void> deleteEntry(String id) async {
    final entries = await _getLocalEntries();
    entries.removeWhere((e) => e.id == id);
    await _saveLocalEntries(entries);

    if (await isOnline() && _userJournalRef != null) {
      try {
        await _userJournalRef!.doc(id).delete();
      } catch (_) {}
    }
  }

  Future<List<JournalEntry>> _getLocalEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString(_storageKey);
    if (savedData == null || savedData.isEmpty) return [];
    try {
      final decoded = jsonDecode(savedData) as List;
      return decoded
          .map((item) => JournalEntry.fromJson(JsonMap.from(item as Map)))
          .where((e) => e.userId == currentUserId || e.userId.isEmpty)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveLocalEntries(List<JournalEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(entries.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }
}