import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quantum_restaurant/core/extensions/context_extension.dart';

import '../../../core/config/config.dart';
import '../../data/models/dataGet/card_item_model.dart';
import '../components/cuper_form_2.dart';

class CheckLineCard extends ConsumerWidget {
  const CheckLineCard({
    super.key,
    required this.cartItem,
    required this.onPressed,
    required this.onPressedDelete,
    this.onTap,
  });

  final CardItemModel cartItem;
  final void Function(BuildContext)? onPressed;
  final void Function(BuildContext)? onPressedDelete;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final scheme = theme.colorScheme;
    final hasDetails =
        (cartItem.ozellikAciklama?.trim().isNotEmpty ?? false) ||
        (cartItem.ozellikAciklama2?.trim().isNotEmpty ?? false) ||
        (cartItem.ozellikAciklama3?.trim().isNotEmpty ?? false) ||
        (cartItem.secenek?.trim().isNotEmpty ?? false) ||
        (cartItem.aciklama?.trim().isNotEmpty ?? false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Slidable(
        key: ValueKey(cartItem.id),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              autoClose: true,
              onPressed: onPressedDelete,
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Sil',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: onPressed,
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.description,
              label: 'Açıklama',
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: scheme.surface,
              border: Border.all(color: scheme.outline.withValues(alpha: 0.14)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Cuperform2(
                ikon: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${cartItem.miktar} X',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scheme.primary,
                    ),
                  ),
                ),
                baslik: Text(
                  cartItem.adi ?? '-',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                komponet: Text(
                  '${Config.formatter.format(cartItem.genel)} ₺',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface,
                  ),
                ),
                altbaslik: hasDetails
                    ? Column(children: _buildDetailItems(context))
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDetailItems(BuildContext context) {
    final List<Widget> items = [];

    if (cartItem.secenek?.trim().isNotEmpty ?? false) {
      items.add(
        _buildDetailLine(
          context,
          text: cartItem.secenek!,
          icon: CupertinoIcons.tag_fill,
          color: Colors.blue[800]!,
        ),
      );
    }

    if (cartItem.ozellikAciklama?.trim().isNotEmpty ?? false) {
      items.add(
        _buildDetailLine(
          context,
          text: cartItem.ozellikAciklama!,
          icon: CupertinoIcons.checkmark_seal_fill,
          color: Colors.green[700]!,
        ),
      );
    }

    if (cartItem.ozellikAciklama2?.trim().isNotEmpty ?? false) {
      items.add(
        _buildDetailLine(
          context,
          text: cartItem.ozellikAciklama2!,
          icon: CupertinoIcons.checkmark_seal_fill,
          color: Colors.green[700]!,
        ),
      );
    }

    if (cartItem.ozellikAciklama3?.trim().isNotEmpty ?? false) {
      items.add(
        _buildDetailLine(
          context,
          text: cartItem.ozellikAciklama3!,
          icon: CupertinoIcons.checkmark_seal_fill,
          color: Colors.green[700]!,
        ),
      );
    }
    if (cartItem.aciklama?.trim().isNotEmpty ?? false) {
      items.add(
        _buildDetailLine(
          context,
          text: cartItem.aciklama!,
          icon: Icons.description_rounded,
          color: Colors.green[700]!,
        ),
      );
    }

    return items;
  }

  Widget _buildDetailLine(
    BuildContext context, {
    required String text,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.theme.textTheme.bodySmall?.copyWith(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
