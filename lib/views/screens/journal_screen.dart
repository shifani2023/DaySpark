import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/journal_entry.dart';
import '../../services/journal_service.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final JournalService _journalService = JournalService();

  List<JournalEntry> _entries = [];
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final entries = await _journalService.getEntries();

    if (!mounted) return;

    setState(() {
      _entries = entries;
      _isLoading = false;
    });
  }

  Future<void> _addEntry() async {
    final result = await showDialog<JournalEntry>(
      context: context,
      builder: (context) => const JournalEditorDialog(),
    );

    if (result != null) {
      await _journalService.addEntry(result);
      await _loadEntries();
    }
  }

  Future<void> _editEntry(JournalEntry entry) async {
    final result = await showDialog<JournalEntry>(
      context: context,
      builder: (context) => JournalEditorDialog(entry: entry),
    );

    if (result != null) {
      await _journalService.updateEntry(result);
      await _loadEntries();
    }
  }

  Future<void> _deleteEntry(JournalEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete case note?'),
        content: const Text(
          'This note will be permanently removed from your Casebook.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _journalService.deleteEntry(entry.id);
      await _loadEntries();
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _tagEmoji(String tag) {
    switch (tag) {
      case 'Suspect Theory':
        return '🕵️';

      case 'Clue Analysis':
        return '🔍';

      case 'Solved Case':
        return '🎉';

      case 'Daily Spark':
        return '✨';

      default:
        return '📝';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _entries.where((e) {
      final q = _searchQuery.toLowerCase();

      return e.title.toLowerCase().contains(q) ||
          e.content.toLowerCase().contains(q);
    }).toList();

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F6FF),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: _loadEntries,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Text(
                      'Detective Casebook 🕵️',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF30264D),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Log suspect theories, clue notes, and daily reflections '
                      '(Offline + Cloud Sync).',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _addEntry,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('New Casebook Note'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7762D8),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search your notes & theories...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    if (filtered.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.auto_stories_outlined,
                              size: 55,
                              color: Color(0xFFB8AFFF),
                            ),

                            SizedBox(height: 12),

                            Text(
                              'No case notes yet',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 6),

                            Text(
                              'Jot down who you suspect in Blackwood Mansion '
                              'or record your daily thoughts.',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                    ...filtered.map(
                      (entry) => Card(
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    _formatDate(entry.date),
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),

                                  const Spacer(),

                                  Text(
                                    '${_tagEmoji(entry.mood)} ${entry.mood}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF7762D8),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              Text(
                                entry.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF30264D),
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                entry.content,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  height: 1.5,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  TextButton.icon(
                                    onPressed: () => _editEntry(entry),
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      size: 18,
                                    ),
                                    label: const Text('Edit'),
                                  ),

                                  const Spacer(),

                                  IconButton(
                                    onPressed: () => _deleteEntry(entry),
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class JournalEditorDialog extends StatefulWidget {
  final JournalEntry? entry;

  const JournalEditorDialog({
    super.key,
    this.entry,
  });

  @override
  State<JournalEditorDialog> createState() =>
      _JournalEditorDialogState();
}

class _JournalEditorDialogState extends State<JournalEditorDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _contentController;

  String _selectedTag = 'Suspect Theory';

  final List<String> _tags = [
    'Suspect Theory',
    'Clue Analysis',
    'Solved Case',
    'Daily Spark',
  ];

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.entry?.title ?? '',
    );

    _contentController = TextEditingController(
      text: widget.entry?.content ?? '',
    );

    _selectedTag = _tags.contains(widget.entry?.mood)
        ? widget.entry!.mood
        : 'Suspect Theory';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();

    super.dispose();
  }

  // UPDATED: Save the Firebase UID with every new or edited note.
  void _saveEntry() {
    if (!_formKey.currentState!.validate()) return;

    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    final entry = JournalEntry(
      id: widget.entry?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),

      // Preserve the original user ID when editing.
      // If it is missing, use the currently logged-in user's UID.
      userId: widget.entry?.userId.isNotEmpty == true
          ? widget.entry!.userId
          : uid,

      title: _titleController.text.trim(),

      content: _contentController.text.trim(),

      mood: _selectedTag,

      date: widget.entry?.date ?? DateTime.now(),
    );

    Navigator.pop(context, entry);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.entry != null;

    return AlertDialog(
      title: Text(
        isEditing ? 'Edit Case Note' : 'New Casebook Note',
      ),

      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  maxLength: 60,
                  decoration: const InputDecoration(
                    labelText: 'Note Title',
                    hintText: 'e.g. Emma\'s Blue Dress Clue',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty)
                          ? 'Enter a title.'
                          : null,
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: _contentController,
                  minLines: 4,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    labelText: 'Evidence & Theory Notes',
                    hintText: 'Write your deductions or thoughts...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty)
                          ? 'Write your note.'
                          : null,
                ),

                const SizedBox(height: 14),

                const Text(
                  'Category:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _tags.map((tag) {
                    return ChoiceChip(
                      label: Text(tag),
                      selected: _selectedTag == tag,
                      onSelected: (sel) {
                        if (sel) {
                          setState(() {
                            _selectedTag = tag;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),

        ElevatedButton(
          onPressed: _saveEntry,
          child: Text(isEditing ? 'Update' : 'Save Note'),
        ),
      ],
    );
  }
}