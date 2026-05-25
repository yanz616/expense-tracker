import 'package:expense_tracker/core/constants/app_constants.dart';
import 'package:expense_tracker/features/transaction/domain/entities/category.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction_status.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction_type.dart';
import 'package:expense_tracker/features/transaction/presentation/widgets/add_transaction/amount_input.dart';
import 'package:expense_tracker/features/transaction/presentation/widgets/add_transaction/category_grid.dart';
import 'package:expense_tracker/features/transaction/presentation/widgets/add_transaction/type_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/transaction_provider.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final Transaction? existing;
  const AddTransactionScreen({super.key, this.existing});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _descCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  bool _saving = false;

  late double _amount;
  late TransactionType _type;
  late TransactionStatus _status;
  late DateTime _date;
  String? _categoryId;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _amount = e?.amount ?? 0;
    _type = e?.type ?? TransactionType.expense;
    _status = e?.status ?? TransactionStatus.settled;
    _date = e?.date ?? DateTime.now();
    _categoryId = e?.categoryId;
    _titleCtrl.text = e?.title ?? '';
    _descCtrl.text = e?.description ?? '';
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  /// ← FIX utama: selalu aman di-pop
  void _safeClose() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppConstants.navDashboard);
    }
  }

  Future<void> _save() async {
    if (_amount <= 0) {
      _showSnack('Please enter an amount');
      return;
    }
    if (_titleCtrl.text.trim().isEmpty) {
      _showSnack('Please enter a title');
      return;
    }
    if (_categoryId == null) {
      _showSnack('Please select a category');
      return;
    }

    setState(() => _saving = true);
    try {
      final actions = ref.read(transactionActionsProvider);
      final tx = Transaction(
        id: _isEdit ? widget.existing!.id : const Uuid().v4(),
        title: _titleCtrl.text.trim(),
        amount: _amount,
        type: _type,
        status: _status,
        categoryId: _categoryId!,
        date: _date,
        description:
            _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
        createdAt: _isEdit ? widget.existing!.createdAt : DateTime.now(),
        updatedAt: _isEdit ? DateTime.now() : null,
      );
      if (_isEdit) {
        await actions.update(tx);
      } else {
        await actions.add(tx);
      }
      if (mounted) _safeClose(); // ← pakai _safeClose
    } catch (e) {
      _showSnack('Error: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.bgOverlay,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Delete transaction?', style: AppTextStyles.bodyLarge),
        content: Text('This action cannot be undone.',
            style: AppTextStyles.labelMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('CANCEL',
                style: AppTextStyles.labelSmall
                    .copyWith(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('DELETE',
                style: AppTextStyles.labelSmall.copyWith(color: AppColors.red)),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      await ref.read(transactionActionsProvider).delete(widget.existing!.id);
      if (mounted) _safeClose(); // ← pakai _safeClose
    }
  }

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg, style: AppTextStyles.labelMedium),
        backgroundColor: AppColors.bgCard,
        behavior: SnackBarBehavior.floating,
      ));

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.blue,
            surface: AppColors.bgOverlay,
            onSurface: AppColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSurface,
      appBar: AppBar(
        backgroundColor: AppColors.bgSurface,
        automaticallyImplyLeading: false,
        title: Row(children: [
          const Icon(Icons.terminal, size: 14, color: AppColors.blue),
          const SizedBox(width: 8),
          Text(
            _isEdit ? 'EDIT_TRANSACTION' : 'ADD_TRANSACTION',
            style: AppTextStyles.headingMedium
                .copyWith(color: AppColors.textPrimary),
          ),
        ]),
        actions: [
          if (_isEdit)
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: AppColors.red, size: 20),
              onPressed: _delete,
            ),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textMuted, size: 22),
            onPressed: _safeClose, // ← pakai _safeClose
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AmountInput(
              initialValue: _amount,
              onChanged: (v) => setState(() => _amount = v),
            ),
            const SizedBox(height: 20),
            Text('TITLE', style: AppTextStyles.headingMedium),
            const SizedBox(height: 10),
            TextField(
              controller: _titleCtrl,
              style: AppTextStyles.bodyMedium,
              cursorColor: AppColors.blue,
              decoration: const InputDecoration(
                  hintText: 'e.g. Makan siang, Gaji, Netflix...'),
            ),
            const SizedBox(height: 20),
            TypeToggle(
              selected: _type,
              onChanged: (t) => setState(() => _type = t),
            ),
            const SizedBox(height: 24),
            Text('SELECT_CATEGORY', style: AppTextStyles.headingMedium),
            const SizedBox(height: 14),
            CategoryGrid(
              selectedId: _categoryId,
              onSelected: (Category c) => setState(() => _categoryId = c.id),
            ),
            const SizedBox(height: 24),
            Text('DATE_TIME', style: AppTextStyles.headingMedium),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.bgInput,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 16, color: AppColors.textMuted),
                  const SizedBox(width: 10),
                  Text(
                    '${_months[_date.month - 1]} ${_date.day}, ${_date.year}',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const Spacer(),
                  Text('CHANGE',
                      style: AppTextStyles.labelSmall
                          .copyWith(color: AppColors.blue, letterSpacing: 1.5)),
                ]),
              ),
            ),
            const SizedBox(height: 20),
            Text('STATUS', style: AppTextStyles.headingMedium),
            const SizedBox(height: 10),
            Row(
              children: TransactionStatus.values.map((s) {
                final isActive = _status == s;
                final color = s == TransactionStatus.pending
                    ? AppColors.pending
                    : AppColors.blue;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _status = s),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: EdgeInsets.only(
                          right: s == TransactionStatus.pending ? 8 : 0),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        color: isActive
                            ? color.withOpacity(0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: isActive ? color : AppColors.border,
                            width: isActive ? 1.5 : 1),
                      ),
                      child: Text(s.label,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: isActive ? color : AppColors.textMuted,
                            fontWeight:
                                isActive ? FontWeight.w700 : FontWeight.w400,
                            letterSpacing: 1.5,
                          )),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text('DESCRIPTION', style: AppTextStyles.headingMedium),
            const SizedBox(height: 10),
            TextField(
              controller: _descCtrl,
              style: AppTextStyles.bodyMedium,
              cursorColor: AppColors.blue,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Add a note...'),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.bgPrimary))
                    : Text(_isEdit ? 'UPDATE_TRANSACTION' : 'SAVE_TRANSACTION'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const _months = [
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
    'Dec'
  ];
}
