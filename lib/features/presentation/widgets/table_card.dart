import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/config.dart';
import '../../../core/utils/utils.dart';
import '../../data/models/dataGet/table_item_model.dart';
import '../module/adisyon_notifier.dart';
import '../pages/adisyon/order_list_view.dart';

class TableCard extends ConsumerWidget {
  const TableCard({super.key, required this.table});
  final TableItemModel table;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adisyonNotifier = ref.watch(adisyonNotifierProvider.notifier);
    final bool isOpen = table.masaAcik == true;
    final bool isBillWritten = table.adisyonYazildi == true;

    final List<Color> gradientColors = isOpen
        ? isBillWritten
              ? [const Color(0xFF5C3A10), const Color(0xFF7A5228)]
              : [const Color(0xFF5A2020), const Color(0xFF7A3535)]
        : [const Color(0xFF1E3A2A), const Color(0xFF2E5540)];

    final Color accentColor = isOpen
        ? isBillWritten
              ? const Color(0xFFD4A96A)
              : const Color(0xFFCC8080)
        : const Color(0xFF6DAF8A);
    return GestureDetector(
      onTap: () async {
        if (table.kisiSayisi == null || table.kisiSayisi == 0) {
          _showPersonCountDialog(context, table);
        } else {
          adisyonNotifier.setPersonCount(table.kisiSayisi!);
          Config.gotopage(
            context,
            OrderListView(masaid: table.id!, masaadi: table.adi.toString()),
            "",
            "Ana Menü",
          );
        }
      },
      child: FadedScaleAnimation(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            boxShadow: [
              BoxShadow(
                color: gradientColors[0].withValues(alpha: 0.45),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.12),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              children: [
                // Decorative circle overlay
                Positioned(
                  top: -28,
                  right: -28,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.07),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -20,
                  left: -20,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.04),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top row: masa adı + durum badge
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              table.adi.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.2,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isOpen
                                  ? (isBillWritten ? 'Adisyon' : 'Açık')
                                  : 'Kapalı',
                              style: TextStyle(
                                color: accentColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Container(
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                      const SizedBox(height: 4),
                      if (isOpen)
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline_rounded,
                              size: 11,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${table.kisiSayisi ?? 0} Kişi',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),

                      // Süre
                      if (isOpen)
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 11,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${Utils.format.format(table.sureDk)} Dk',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      // const SizedBox(height: 4),
                      // Alt satır: garson + toplam
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person_rounded,
                                  size: 11,
                                  color: Colors.white.withValues(alpha: 0.75),
                                ),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                    isOpen ? '${table.acanGarson}' : 'Kapalı',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white.withValues(
                                        alpha: 0.85,
                                      ),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (table.sonUrun != null)
                            Text(
                              '₺${Utils.format.format(table.toplam)}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPersonCountDialog(BuildContext context, TableItemModel table) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final isDark = theme.brightness == Brightness.dark;
        final dialogBackground = Color.lerp(
          colorScheme.surface,
          colorScheme.primary,
          isDark ? 0.12 : 0.05,
        )!;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 4,
          backgroundColor: dialogBackground,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 360),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: dialogBackground,
              border: Border.all(
                color: colorScheme.outline.withValues(
                  alpha: isDark ? 0.35 : 0.2,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Consumer(
              builder: (context, ref, child) {
                final personCount = ref
                    .watch(adisyonNotifierProvider)
                    .personCount;
                final adisyonNotifier = ref.watch(
                  adisyonNotifierProvider.notifier,
                );
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.people_alt_rounded,
                                  size: 20,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Kişi Sayısı',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: colorScheme.onSurface,
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      table.adi ?? '',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: colorScheme.onSurface
                                                .withValues(alpha: 0.7),
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surface.withValues(
                                alpha: isDark ? 0.28 : 0.55,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: colorScheme.outline.withValues(
                                  alpha: isDark ? 0.3 : 0.2,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (personCount > 1) {
                                      adisyonNotifier.removePersonCount();
                                    }
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    curve: Curves.easeInOut,
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: personCount > 1
                                          ? colorScheme.primary
                                          : colorScheme.surface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: colorScheme.outline.withValues(
                                          alpha: 0.25,
                                        ),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.remove_rounded,
                                      color: personCount > 1
                                          ? colorScheme.onPrimary
                                          : colorScheme.onSurface.withValues(
                                              alpha: 0.4,
                                            ),
                                      size: 20,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 74,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary.withValues(
                                      alpha: isDark ? 0.22 : 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: colorScheme.primary.withValues(
                                        alpha: 0.45,
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AnimatedDefaultTextStyle(
                                          duration: const Duration(
                                            milliseconds: 180,
                                          ),
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                            color: colorScheme.primary,
                                          ),
                                          child: Text('$personCount'),
                                        ),
                                        Text(
                                          'Kişi',
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                                color: colorScheme.onSurface
                                                    .withValues(alpha: 0.7),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (personCount < 10) {
                                      adisyonNotifier.addPersonCount();
                                    }
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    curve: Curves.easeInOut,
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: personCount < 10
                                          ? colorScheme.primary
                                          : colorScheme.surface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: colorScheme.outline.withValues(
                                          alpha: 0.25,
                                        ),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.add_rounded,
                                      color: personCount < 10
                                          ? colorScheme.onPrimary
                                          : colorScheme.onSurface.withValues(
                                              alpha: 0.4,
                                            ),
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Min: 1  Max: 10',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 42,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      adisyonNotifier.setPersonCount(1);
                                    },
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      size: 18,
                                    ),
                                    label: const Text('İptal'),
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: SizedBox(
                                  height: 42,
                                  child: FilledButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Config.gotopage(
                                        context,
                                        OrderListView(
                                          masaid: table.id!,
                                          masaadi: table.adi.toString(),
                                        ),
                                        "",
                                        "Ana Menü",
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 18,
                                    ),
                                    label: const Text('Devam Et'),
                                    style: FilledButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
