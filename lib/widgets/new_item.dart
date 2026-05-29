import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;
  var _isSending = false;

  // ── EXACT SAME LOGIC AS ORIGINAL ─────────────────────────────

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() => _isSending = true);

      final url = Uri.https(
          'flutter-prep-shopping-li-156b7-default-rtdb.firebaseio.com',
          'shopping-list.json');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _enteredName,
          'quantity': _enteredQuantity,
          'category': _selectedCategory.title,
        }),
      );

      final Map<String, dynamic> resData = json.decode(response.body);

      if (!context.mounted) return;

      Navigator.of(context).pop(
        GroceryItem(
          id: resData['name'],
          name: _enteredName,
          quantity: _enteredQuantity,
          category: _selectedCategory,
        ),
      );
    }
  }

  // ── colours ───────────────────────────────────────────────────
  static const _bg = Color(0xFF0F1117);
  static const _card = Color(0xFF222533);
  static const _border = Color(0xFF2D3148);
  static const _accent = Color(0xFF4ADE80);
  static const _textPrimary = Color(0xFFF1F5F9);
  static const _textSecondary = Color(0xFF94A3B8);

  // ── BUILD ─────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _border),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 15, color: _textPrimary),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Add Item',
          style: TextStyle(
              color: _textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 8),

              // ── Name ────────────────────────────────────────
              _sectionLabel('Item Name'),
              const SizedBox(height: 10),
              TextFormField(
                maxLength: 50,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(color: _textPrimary),
                decoration: const InputDecoration(
                  hintText: 'e.g. Organic Spinach',
                  prefixIcon: Icon(Icons.shopping_bag_outlined,
                      color: _textSecondary, size: 20),
                  counterStyle: TextStyle(color: _textSecondary),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters.';
                  }
                  return null;
                },
                onSaved: (value) => _enteredName = value!,
              ),

              const SizedBox(height: 24),

              // ── Quantity ────────────────────────────────────
              _sectionLabel('Quantity'),
              const SizedBox(height: 10),
              _QuantityStepper(
                initial: _enteredQuantity,
                onChanged: (val) => setState(() => _enteredQuantity = val),
                formKey: _formKey,
                onSaved: (val) => _enteredQuantity = val,
              ),

              const SizedBox(height: 24),

              // ── Category ────────────────────────────────────
              _sectionLabel('Category'),
              const SizedBox(height: 12),
              _CategoryGrid(
                selected: _selectedCategory,
                onSelect: (cat) => setState(() => _selectedCategory = cat),
              ),

              const SizedBox(height: 40),

              // ── Actions ─────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _isSending
                          ? null
                          : () => _formKey.currentState!.reset(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        foregroundColor: _textSecondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: _border),
                        ),
                      ),
                      child: const Text('Reset',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isSending ? null : _saveItem,
                        child: _isSending
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Color(0xFF052E16),
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_circle_outline_rounded,
                                      size: 18),
                                  SizedBox(width: 8),
                                  Text('Add Item'),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        color: _textSecondary,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
      ),
    );
  }
}

// ── Quantity stepper ──────────────────────────────────────────────

class _QuantityStepper extends StatefulWidget {
  final int initial;
  final ValueChanged<int> onChanged;
  final GlobalKey<FormState> formKey;
  final ValueChanged<int> onSaved;

  const _QuantityStepper({
    required this.initial,
    required this.onChanged,
    required this.formKey,
    required this.onSaved,
  });

  @override
  State<_QuantityStepper> createState() => _QuantityStepperState();
}

class _QuantityStepperState extends State<_QuantityStepper> {
  late final TextEditingController _controller;

  static const _card = Color(0xFF222533);
  static const _border = Color(0xFF2D3148);
  static const _accent = Color(0xFF4ADE80);
  static const _textPrimary = Color(0xFFF1F5F9);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initial.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _change(int delta) {
    final current = int.tryParse(_controller.text) ?? 1;
    final next = (current + delta).clamp(1, 99);
    _controller.text = next.toString();
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          _stepBtn(Icons.remove_rounded, () => _change(-1)),
          Expanded(
            child: TextFormField(
              controller: _controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700),
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                counterText: '',
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    int.tryParse(value) == null ||
                    int.tryParse(value)! <= 0) {
                  return 'Enter a valid quantity';
                }
                return null;
              },
              onSaved: (value) => widget.onSaved(int.parse(value!)),
              onChanged: (value) {
                final n = int.tryParse(value);
                if (n != null) widget.onChanged(n);
              },
            ),
          ),
          _stepBtn(Icons.add_rounded, () => _change(1)),
        ],
      ),
    );
  }

  Widget _stepBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        alignment: Alignment.center,
        child: Icon(icon, color: _accent, size: 22),
      ),
    );
  }
}

// ── Category grid ─────────────────────────────────────────────────

class _CategoryGrid extends StatelessWidget {
  final Category selected;
  final ValueChanged<Category> onSelect;

  static const _card = Color(0xFF222533);
  static const _border = Color(0xFF2D3148);
  static const _textSecondary = Color(0xFF94A3B8);

  const _CategoryGrid({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final entry in categories.entries)
          _CategoryChip(
            category: entry.value,
            isSelected: entry.value.title == selected.title,
            onTap: () => onSelect(entry.value),
          ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  static const _card = Color(0xFF222533);
  static const _border = Color(0xFF2D3148);

  const _CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? category.color.withOpacity(0.15)
              : _card,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? category.color : _border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: category.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              category.title,
              style: TextStyle(
                color: isSelected ? category.color : const Color(0xFF94A3B8),
                fontSize: 13,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}