import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme_mode_cubit.dart';
import '../../module/table_card_theme_notifier.dart';

class TableCardThemePage extends ConsumerWidget {
  const TableCardThemePage({super.key});

  static const List<Color> _palette = [
    Color(0xFF5A2020),
    Color(0xFF7B1E3A),
    Color(0xFF6A1B1B),
    Color(0xFF5C3A10),
    Color(0xFF8A5A22),
    Color(0xFF1E3A2A),
    Color(0xFF25543A),
    Color(0xFF0E4F66),
    Color(0xFF1F3B73),
    Color(0xFF4C2A6A),
    Color(0xFF3A3A3A),
    Color(0xFF455A64),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(tableCardThemeNotifierProvider);
    final notifier = ref.read(tableCardThemeNotifierProvider.notifier);
    final selectedThemeMode = context.watch<ThemeModeCubit>().state;

    return Scaffold(
      appBar: AppBar(title: const Text('Tema Seçenekleri'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Bu sayfadan masa kartlarinin Açık, Kapalı ve Adisyon renklerini seçip kaydedebilirsiniz.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _ThemeModeSection(
              selectedMode: selectedThemeMode,
              onSelected: (mode) {
                context.read<ThemeModeCubit>().setThemeMode(mode);
              },
            ),
            const SizedBox(height: 16),
            _ColorSection(
              title: 'Açık Masa Rengi',
              selectedColor: themeState.openTableColor,
              palette: _palette,
              onSelected: (color) => notifier.setOpenTableColor(color),
            ),
            const SizedBox(height: 16),
            _ColorSection(
              title: 'Kapalı Masa Rengi',
              selectedColor: themeState.closedTableColor,
              palette: _palette,
              onSelected: (color) => notifier.setClosedTableColor(color),
            ),
            const SizedBox(height: 16),
            _ColorSection(
              title: 'Adisyon Yazıldı Rengi',
              selectedColor: themeState.billWrittenTableColor,
              palette: _palette,
              onSelected: (color) => notifier.setBillWrittenTableColor(color),
            ),
            const SizedBox(height: 20),
            _TableCardPreview(
              openColor: themeState.openTableColor,
              closedColor: themeState.closedTableColor,
              billColor: themeState.billWrittenTableColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeModeSection extends StatelessWidget {
  final ThemeMode selectedMode;
  final ValueChanged<ThemeMode> onSelected;

  const _ThemeModeSection({
    required this.selectedMode,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                'Uygulama Teması',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.system,
              groupValue: selectedMode,
              onChanged: (value) {
                if (value != null) onSelected(value);
              },
              title: const Text('Sistem Varsayılanı'),
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.light,
              groupValue: selectedMode,
              onChanged: (value) {
                if (value != null) onSelected(value);
              },
              title: const Text('Açık Tema'),
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: selectedMode,
              onChanged: (value) {
                if (value != null) onSelected(value);
              },
              title: const Text('Koyu Tema'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorSection extends StatelessWidget {
  final String title;
  final Color selectedColor;
  final List<Color> palette;
  final ValueChanged<Color> onSelected;

  const _ColorSection({
    required this.title,
    required this.selectedColor,
    required this.palette,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: palette.map((color) {
                final bool isSelected =
                    color.toARGB32() == selectedColor.toARGB32();
                return InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () => onSelected(color),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onSurface
                            : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 18,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _TableCardPreview extends StatelessWidget {
  final Color openColor;
  final Color closedColor;
  final Color billColor;

  const _TableCardPreview({
    required this.openColor,
    required this.closedColor,
    required this.billColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Önizleme',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _PreviewCard(title: 'Açık', color: openColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _PreviewCard(title: 'Kapalı', color: closedColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _PreviewCard(title: 'Adisyon', color: billColor),
            ),
          ],
        ),
      ],
    );
  }
}

class _PreviewCard extends StatelessWidget {
  final String title;
  final Color color;

  const _PreviewCard({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            Color.lerp(color, Colors.black, 0.18) ?? color,
            Color.lerp(color, Colors.white, 0.12) ?? color,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
