import 'package:coffee/controllers/redeem_history_controller.dart';
import 'package:coffee/models/transaction_history_model.dart';
import 'package:coffee/utils/color.dart';
import 'package:coffee/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

DateTime? _parseTransactionTimestamp(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return null;
  // Integer timestamps must run before tryParse: e.g. "1778386442" is wrongly read as
  // year 177843-05-12 by DateTime.tryParse (compact ISO-like digits).
  if (RegExp(r'^\d+$').hasMatch(trimmed)) {
    final n = int.tryParse(trimmed);
    if (n != null) {
      if (n > 10000000000) {
        return DateTime.fromMillisecondsSinceEpoch(n, isUtc: true);
      }
      return DateTime.fromMillisecondsSinceEpoch(n * 1000, isUtc: true);
    }
    return null;
  }
  return DateTime.tryParse(trimmed);
}

String _formatTransactionTimestamp(BuildContext context, String raw) {
  final parsed = _parseTransactionTimestamp(raw);
  if (parsed == null) return raw;
  final local = parsed.toLocal();
  final locale = Localizations.localeOf(context).toString();
  final date = DateFormat.yMMMd(locale).format(local);
  final time = DateFormat.jm(locale).format(local);
  return '$date, $time';
}

class RedeemHistoryScreen extends GetView<RedeemHistoryController> {
  const RedeemHistoryScreen({super.key});

  static const _redeemTypeItems = <_FilterItem>[
    _FilterItem(label: 'All', value: ''),
    _FilterItem(label: 'Earn', value: 'earn'),
    _FilterItem(label: 'Redeem', value: 'redeem'),
  ];

  static const _sourceItems = <_FilterItem>[
    _FilterItem(label: 'All', value: ''),
    _FilterItem(label: 'Halatree', value: 'bigcommerce'),
    _FilterItem(label: 'Clover', value: 'clover'),
  ];

  String _sourceLabel(String? source) {
    final s = (source ?? '').toLowerCase();
    if (s == 'bigcommerce') return 'Halatree';
    if (s == 'clover') return 'Clover';
    if (s.isEmpty) return '—';
    return source ?? '—';
  }

  String _typeLabel(String? type) {
    final t = (type ?? '').toLowerCase();
    if (t == 'earn') return 'Earn';
    if (t == 'redeem') return 'Redeem';
    return type?.isNotEmpty == true ? type! : '—';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text('Redeem history', style: GoogleFonts.roboto(fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _FilterDropdown(
                            label: 'Type',
                            items: _redeemTypeItems,
                            value: controller.redeemTypeParam.value,
                            onChanged: (v) => controller.redeemTypeParam.value = v,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _FilterDropdown(
                            label: 'Source',
                            items: _sourceItems,
                            value: controller.sourceParam.value,
                            onChanged: (v) => controller.sourceParam.value = v,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: colorPrimaryDark,
                        foregroundColor: colorOnPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: controller.loading.value ? null : controller.fetchHistory,
                      child: Text(
                        'Filter',
                        style: GoogleFonts.roboto(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                  ],
                );
              }),
            ),
            Expanded(
              child: Obx(() {
                if (controller.loading.value && controller.transactions.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.transactions.isEmpty) {
                  final uid = Constants.userModel?.id;
                  final message = (uid == null || uid.isEmpty)
                      ? 'Sign in to see your history.'
                      : 'No transactions match these filters.';
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(fontSize: 16, color: colorOnSurface),
                      ),
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: controller.fetchHistory,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: controller.transactions.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      return _TransactionTile(
                        tx: controller.transactions[i],
                        sourceLabel: _sourceLabel,
                        typeLabel: _typeLabel,
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterItem {
  final String label;
  final String value;

  const _FilterItem({required this.label, required this.value});
}

class _FilterDropdown extends StatelessWidget {
  final String label;
  final List<_FilterItem> items;
  final String value;
  final void Function(String)? onChanged;

  const _FilterDropdown({
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: colorSurface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _resolvedValue(),
          items: items
              .map(
                (e) => DropdownMenuItem<String>(
                  value: e.value,
                  child: Text(e.label, style: GoogleFonts.roboto(fontSize: 14)),
                ),
              )
              .toList(),
          onChanged: onChanged == null ? null : (v) => onChanged!(v ?? ''),
        ),
      ),
    );
  }

  String _resolvedValue() {
    for (final e in items) {
      if (e.value == value) return value;
    }
    return items.first.value;
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionHistoryModel tx;
  final String Function(String?) sourceLabel;
  final String Function(String?) typeLabel;

  const _TransactionTile({
    required this.tx,
    required this.sourceLabel,
    required this.typeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final type = (tx.type ?? '').toLowerCase();
    final isEarn = type == 'earn';
    final isRedeem = type == 'redeem';
    final points = tx.points ?? '';
    final pointsDisplay = points.isEmpty
        ? '—'
        : (isEarn ? '+$points' : (isRedeem ? '-$points' : points));

    return Material(
      color: colorSurface,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorOutline.withValues(alpha: 0.6)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorPrimary.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    typeLabel(tx.type),
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colorOnBackground,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  pointsDisplay,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isEarn
                        ? const Color(0xFF2E7D32)
                        : (isRedeem ? colorPrimaryDark : colorOnBackground),
                  ),
                ),
                const SizedBox(width: 4),
                Text('pts', style: GoogleFonts.roboto(fontSize: 12, color: colorOnSurface)),
              ],
            ),
            if ((tx.notes ?? '').isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                tx.notes!,
                style: GoogleFonts.roboto(fontSize: 14, color: colorOnBackground, height: 1.35),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.storefront_outlined, size: 16, color: colorOnSurface),
                const SizedBox(width: 6),
                Text(
                  sourceLabel(tx.source),
                  style: GoogleFonts.roboto(fontSize: 13, color: colorOnSurface),
                ),
                const Spacer(),
                if ((tx.created_at ?? '').isNotEmpty)
                  Text(
                    _formatTransactionTimestamp(context, tx.created_at!),
                    style: GoogleFonts.roboto(fontSize: 12, color: colorOnSurface),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
