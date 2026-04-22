import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../core/routes/route_names.dart';
import '../../data/models/dataPost/login_model.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final userName =
        ref.watch(loginModelProvider)?.adiSoyadi.trim().isNotEmpty == true
        ? ref.watch(loginModelProvider)!.adiSoyadi.trim()
        : 'Garson';
    final initial = userName.trim().isNotEmpty
        ? userName.trim().characters.first.toUpperCase()
        : 'G';

    return Drawer(
      child: Material(
        color: theme.scaffoldBackgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [colorScheme.primary, colorScheme.tertiary],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.22),
                      blurRadius: 24,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Menü',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          visualDensity: VisualDensity.compact,
                          splashRadius: 18,
                          icon: Icon(
                            CupertinoIcons.xmark,
                            color: Colors.white.withValues(alpha: 0.95),
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            initial,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Quantum Restaurant',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 14, 12, 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.14),
                      ),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      children: [
                        _buildMenuTile(
                          context: context,
                          icon: Icons.description_rounded,
                          title: 'Hazır Açıklamalar',
                          subtitle: 'Sık kullanılan metinleri düzenleyin',
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.of(
                              context,
                            ).pushNamed(RouteNames.fastDescriptionPage);
                          },
                        ),
                        _buildMenuTile(
                          context: context,
                          icon: Icons.list_alt_rounded,
                          title: 'Uygulama Logları',
                          subtitle: 'İstek ve hata geçmişini görüntüleyin',
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.of(
                              context,
                            ).pushNamed(RouteNames.appLogsPage);
                          },
                        ),
                        _buildMenuTile(
                          context: context,
                          icon: Icons.color_lens_rounded,
                          title: 'Tema Seçenekleri',
                          subtitle: 'Kart görünümü ve görsel ayarlar',
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.of(
                              context,
                            ).pushNamed(RouteNames.tableCardThemePage);
                          },
                        ),
                        const SizedBox(height: 6),
                        _buildMenuTile(
                          context: context,
                          icon: Icons.power_settings_new,
                          title: 'Çıkış',
                          subtitle: 'Oturumu güvenli şekilde sonlandır',
                          destructive: true,
                          onTap: () {
                            Navigator.pop(context);
                            _signOut(context, ref);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 6, 18, 18),
                child: Text(
                  'Copyright © 2005 Quantum Yazılım',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.hintColor.withValues(alpha: 0.66),
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool destructive = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final iconColor = destructive ? Colors.red.shade400 : colorScheme.primary;
    final tileBg = destructive
        ? Colors.red.withValues(alpha: 0.03)
        : colorScheme.primary.withValues(alpha: 0.03);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: tileBg,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: destructive
                    ? Colors.red.withValues(alpha: 0.18)
                    : colorScheme.outline.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: destructive
                              ? Colors.red.shade400
                              : colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.hintColor.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Icon(
                    CupertinoIcons.chevron_forward,
                    size: 16,
                    color: theme.hintColor.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final userName =
        ref.read(loginModelProvider)?.adiSoyadi.trim().isNotEmpty == true
        ? ref.read(loginModelProvider)!.adiSoyadi.trim()
        : 'Garson';
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return CupertinoActionSheet(
              title: Text(
                "$userName hesabından çıkış yapılacak.\nDevam edilsin mi?",
              ),
              cancelButton: CupertinoActionSheetAction(
                child: const Text("Vazgeç"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <CupertinoActionSheetAction>[
                CupertinoActionSheetAction(
                  isDestructiveAction: true,
                  child: const Text("Devam et"),
                  onPressed: () async {
                    Box box1;

                    box1 = await Hive.openBox('logininfo');

                    box1.put('password', '');

                    //ÇIKIŞ YAP METODu
                    if (!context.mounted) return;

                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/',
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
