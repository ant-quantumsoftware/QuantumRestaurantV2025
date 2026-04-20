import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/dataPost/adisyon_model.dart';
import '../../data/models/food_item_info.dart';
import '../components/input2.dart';
import '../module/adisyon_notifier.dart';
import '../pages/cuper_alert.dart';

class AddCheckDialog extends ConsumerStatefulWidget {
  final int masaid, urunid;
  final String masaadi, urunadi, aciklama;
  final double mevcut;
  final List<SecenekModel> fruitliste;
  final bool adisyon;
  final VoidCallback? onOrderAdded;

  const AddCheckDialog({
    super.key,
    required this.masaid,
    required this.masaadi,
    required this.urunid,
    required this.urunadi,
    required this.aciklama,
    required this.mevcut,
    required this.fruitliste,
    required this.adisyon,
    this.onOrderAdded,
  });

  @override
  ConsumerState<AddCheckDialog> createState() => _AddCheckDialogState();
}

class _AddCheckDialogState extends ConsumerState<AddCheckDialog> {
  bool _isLoading = true;
  bool _isSubmitting = false;
  double _activeAmount = 1.0;
  String _selectedOption = "";
  late TextEditingController _descriptionController;
  late List<SecenekModel> _options;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _initializeData() {
    _activeAmount = widget.mevcut < 0.5 ? 1.0 : widget.mevcut;
    _descriptionController = TextEditingController(text: widget.aciklama);
    _options = List.from(widget.fruitliste);

    setState(() {
      _isLoading = false;
    });
  }

  void _adjustAmount(double delta) {
    setState(() {
      final next = (_activeAmount + delta).clamp(0.5, 10000.0);
      _activeAmount = (next * 2).round() / 2;
    });
  }

  String get _formattedAmount {
    if (_activeAmount == _activeAmount.roundToDouble()) {
      return _activeAmount.toStringAsFixed(0);
    }
    return _activeAmount.toStringAsFixed(1);
  }

  void _onOptionSelected(int index) {
    setState(() {
      // Tüm seçenekleri false yap
      for (var option in _options) {
        option.selected = false;
      }
      // Seçilen seçeneği true yap
      _options[index].selected = true;
      _selectedOption = _options[index].secenek!;
    });
  }

  bool _validateForm() {
    if (_options.isNotEmpty) {
      final selectedOptions = _options
          .where((option) => option.selected == true)
          .toList();
      if (selectedOptions.isEmpty) {
        CuperAlert.show(
          context: context,
          destructive: true,
          title: 'Hata',
          content: 'Ürün seçeneği seçin.',
        );
        return false;
      }
    }
    return true;
  }

  Future<void> _submitForm() async {
    if (_isSubmitting) return;
    if (!_validateForm()) return;
    final personCount = ref.read(adisyonNotifierProvider).personCount;
    setState(() {
      _isSubmitting = true;
    });

    try {
      if (widget.adisyon) {
        // Güncelleme işlemi
        await _updateOrder();
      } else {
        // Yeni ekleme işlemi
        final model = AdisyonModel(
          id: 0,
          kisisayisi: personCount,
          miktar: _activeAmount,
          malzemeid: widget.urunid,
          fiyatd: 0,
          secenek: _selectedOption,
          ozellik1: _descriptionController.text,
          ozellik2: "",
          ozellik3: "",
          masaid: widget.masaid,
          adi: widget.urunadi,
        );

        final success1 = await ref
            .read(adisyonNotifierProvider.notifier)
            .saveOrder(model);

        if (!success1 && mounted) {
          CuperAlert.show(
            context: context,
            destructive: true,
            title: 'Ürün Ekleme Hatası! ${widget.urunadi}',
            content: 'Bağlantınızı kontrol ediniz!',
          );
        } else {
          // Sipariş başarıyla eklendi, callback'i çağır
          if (widget.onOrderAdded != null) {
            widget.onOrderAdded!();
          }
          if (mounted) {
            Navigator.pop(context);
          }
        }
      }
    } catch (e) {
      if (!mounted) return;
      CuperAlert.show(
        context: context,
        destructive: true,
        title: 'Hata',
        content: 'İşlem sırasında bir hata oluştu: ${e.toString()}',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _updateOrder() async {
    // Güncelleme için AdisyonModel oluştur
    final personCount = ref.read(adisyonNotifierProvider).personCount;
    final model = AdisyonModel(
      id: widget.urunid, // Güncellenecek siparişin ID'si
      kisisayisi: personCount,
      miktar: _activeAmount,
      malzemeid: widget.urunid,
      fiyatd: 0,
      secenek: _selectedOption,
      ozellik1: _descriptionController.text,
      ozellik2: "",
      ozellik3: "",
      masaid: widget.masaid,
      adi: widget.urunadi,
    );

    // Güncelleme işlemini yap
    final success = await ref
        .read(adisyonNotifierProvider.notifier)
        .updateOrder(model);

    if (!success && mounted) {
      CuperAlert.show(
        context: context,
        destructive: true,
        title: 'Ürün Güncelleme Hatası! ${widget.urunadi}',
        content: 'Bağlantınızı kontrol ediniz!',
      );
    } else {
      // Güncelleme başarılı, callback'i çağır
      if (widget.onOrderAdded != null) {
        widget.onOrderAdded!();
      }
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Widget _buildQuantitySection() {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 8, 10, 6),
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Miktar',
            style: TextStyle(
              color: scheme.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: scheme.outline.withValues(alpha: 0.3)),
            ),
            child: Text(
              _formattedAmount,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: scheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildAdjustRow('1 birim arttır/azalt', 1.0),
          const SizedBox(height: 6),
          _buildAdjustRow('0.5 birim arttır/azalt', 0.5),
        ],
      ),
    );
  }

  Widget _buildAdjustRow(String label, double step) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: scheme.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: _buildAdjustButton(
                  label: 'AZALT',
                  icon: CupertinoIcons.minus,
                  isIncrement: false,
                  onTap: () => _adjustAmount(-step),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAdjustButton(
                  label: 'ARTTIR',
                  icon: CupertinoIcons.add,
                  isIncrement: true,
                  onTap: () => _adjustAmount(step),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdjustButton({
    required String label,
    required IconData icon,
    required bool isIncrement,
    required VoidCallback onTap,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final Color accent = isIncrement ? scheme.primary : scheme.error;

    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          height: 46,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: accent.withValues(alpha: 0.3),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: accent),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsSection() {
    if (_options.isEmpty) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    final desiredHeight = (40.0 * _options.length) + 12;

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 6),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: scheme.outline.withValues(alpha: 0.2),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seçenekler',
            style: TextStyle(
              color: scheme.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: desiredHeight.clamp(60.0, 180.0),
            child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: _options.length,
              separatorBuilder: (context, index) => const SizedBox(height: 3),
              itemBuilder: (context, index) => _buildOptionItem(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionItem(int index) {
    final option = _options[index];
    final isSelected = option.selected ?? false;
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isSelected
            ? scheme.primary.withValues(alpha: 0.14)
            : scheme.surface,
        border: Border.all(
          color: isSelected ? scheme.primary : scheme.outline,
          width: 1.0,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _onOptionSelected(index),
        child: SizedBox(
          height: 34,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  option.secenek!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? scheme.primary : scheme.onSurface,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
              Transform.scale(
                scale: 0.84,
                child: CupertinoCheckbox(
                  activeColor: scheme.primary,
                  value: isSelected,
                  onChanged: (_) => _onOptionSelected(index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    final scheme = Theme.of(context).colorScheme;
    return ExpansionTile(
      dense: true,
      tilePadding: const EdgeInsets.symmetric(horizontal: 10),
      childrenPadding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
      iconColor: scheme.primary,
      collapsedIconColor: scheme.primary,
      title: Text(
        "Açıklama",
        style: TextStyle(
          fontSize: 14,
          color: scheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        "Siparişe açıklama yaz",
        style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 11),
      ),
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: scheme.surfaceContainer,
          ),
          child: Input2(
            texteditcontrol: _descriptionController,
            maxline: 2,
            label: "Açıklama yazın...",
            inputValue: _descriptionController.text,
            textValue: (val) {
              // Description update logic if needed
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: CupertinoActivityIndicator(radius: 15.0)),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        FadeInUp(
          duration: const Duration(milliseconds: 220),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 16,
            height: 46,
            child: MaterialButton(
              onPressed: _isSubmitting
                  ? null
                  : () async {
                      await _submitForm();
                    },
              color: _isSubmitting
                  ? scheme.surfaceContainerHighest
                  : scheme.primary,
              splashColor: scheme.primary.withValues(alpha: 0.3),
              highlightColor: scheme.primary.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
              child: _isSubmitting
                  ? CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation(scheme.onPrimary),
                      strokeWidth: 2.5,
                    )
                  : Text(
                      widget.adisyon ? 'Güncelle' : "Ekle",
                      style: TextStyle(
                        color: scheme.onPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ],
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildQuantitySection(),
            _buildOptionsSection(),
            const SizedBox(height: 2),
            _buildDescriptionSection(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
