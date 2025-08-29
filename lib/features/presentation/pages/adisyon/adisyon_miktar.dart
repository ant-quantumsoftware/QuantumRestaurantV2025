import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinbox/cupertino.dart';

import '../../components/cuper_form_2.dart';
import '../../components/input2.dart';
import '../../components/tablo_satir.dart';
import '../../../data/models/food_item_info.dart';
import '../../../data/models/dataPost/adisyon_model.dart';
import '../../pages/cuper_alert.dart';
import '../adisyon/module/adisyon_notifier.dart';

class AdsMiktar extends ConsumerStatefulWidget {
  final int masaid, urunid;
  final String masaadi, urunadi, aciklama;
  final double mevcut;
  final List<SecenekModel> fruitliste;
  final bool adisyon;
  final VoidCallback? onOrderAdded;

  const AdsMiktar({
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
  ConsumerState<AdsMiktar> createState() => _AdsMiktarState();
}

class _AdsMiktarState extends ConsumerState<AdsMiktar> {
  bool _isLoading = true;
  bool _isSubmitting = false;
  int _stepMode = 1; // 0: 0.5 step, 1: 1 step
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
    _activeAmount = widget.mevcut;
    _descriptionController = TextEditingController(text: widget.aciklama);
    _options = List.from(widget.fruitliste);

    setState(() {
      _isLoading = false;
    });
  }

  String get _stepDescription => _stepMode == 1
      ? "Butonlar - 1 + olarak işlem yapacak"
      : "Butonlar - 0.5 + olarak işlem yapacak";

  double get _minValue => _stepMode == 0 ? 0.5 : 1.0;
  double get _stepValue => _stepMode == 0 ? 0.5 : 1.0;
  String get _stepSuffix => _stepMode == 0 ? '+0.5' : '+1';
  String get _stepPrefix => _stepMode == 0 ? '-0.5' : '-1';

  void _onStepModeChanged(bool value) {
    setState(() {
      _stepMode = value ? 1 : 0;
      if (value) {
        _activeAmount = 1.0;
      }
    });
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
          kisisayisi: 1,
          miktar: _activeAmount,
          malzemeid: widget.urunid,
          fiyatd: 0,
          secenek: _selectedOption,
          ozellik1: "",
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
    final model = AdisyonModel(
      id: widget.urunid, // Güncellenecek siparişin ID'si
      kisisayisi: 1,
      miktar: _activeAmount,
      malzemeid: widget.urunid,
      fiyatd: 0,
      secenek: _selectedOption,
      ozellik1: "",
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
    return FormSatir(
      aktif: true,
      baslik: CupertinoSpinBox(
        showButtons: true,
        onChanged: (value) => _activeAmount = value,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        min: _minValue,
        max: 10000,
        step: _stepValue,
        value: _activeAmount,
        decimals: 2,
        suffix: Text(_stepSuffix),
        prefix: Text(_stepPrefix),
        incrementIcon: const Icon(CupertinoIcons.add_circled_solid, size: 60),
        decrementIcon: const Icon(CupertinoIcons.minus_circle_fill, size: 60),
        textStyle: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).hintColor,
        ),
      ),
    );
  }

  Widget _buildStepModeSection() {
    return FormSatir(
      aktif: true,
      baslik: Text(_stepDescription),
      komponet: CupertinoSwitch(
        value: _stepMode == 1,
        onChanged: _onStepModeChanged,
      ),
    );
  }

  Widget _buildOptionsSection() {
    if (_options.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.purple, width: 1.0),
      ),
      height: 65.0 * _options.length,
      constraints: BoxConstraints(
        maxHeight: 65.0 * _options.length,
        minHeight: 65.0,
      ),
      child: ListView.separated(
        padding: const EdgeInsets.all(15),
        shrinkWrap: true,
        itemCount: _options.length,
        separatorBuilder: (context, index) => const Divider(height: 10),
        itemBuilder: (context, index) => _buildOptionItem(index),
      ),
    );
  }

  Widget _buildOptionItem(int index) {
    final option = _options[index];
    final isSelected = option.selected ?? false;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: isSelected
            ? const Color.fromARGB(157, 69, 39, 176)
            : Colors.grey.withValues(alpha: 0.1),
        border: Border.all(
          color: isSelected
              ? Colors.purple
              : Colors.grey.withValues(alpha: 0.3),
          width: 1.0,
        ),
      ),
      child: Cuperform2(
        onpress: () => _onOptionSelected(index),
        baslik: Text(
          option.secenek!,
          style: TextStyle(
            color: isSelected ? Colors.white : Theme.of(context).hintColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        komponet: CupertinoCheckbox(
          activeColor: Colors.green,
          value: isSelected,
          onChanged: (_) => _onOptionSelected(index),
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return ExpansionTile(
      title: const Text(
        "Açıklama",
        style: TextStyle(fontSize: 20, color: Colors.blue),
      ),
      subtitle: const Text("Siparişe açıklama yaz"),
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),

            border: Border.all(color: Colors.purple, width: 1.0),
          ),
          child: Input2(
            texteditcontrol: _descriptionController,
            maxline: 3,
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
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: CupertinoActivityIndicator(radius: 15.0)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        FadeInUp(
          duration: const Duration(milliseconds: 500),
          child: SizedBox(
            width: 300,
            height: 50,
            child: MaterialButton(
              onPressed: _isSubmitting
                  ? null
                  : () async {
                      await _submitForm();
                    },
              color: _isSubmitting ? Colors.grey : Colors.blue,
              splashColor: Colors.blue.withValues(alpha: 0.3),
              highlightColor: Colors.blue.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: _isSubmitting
                  ? const CupertinoActivityIndicator(color: Colors.white)
                  : Text(
                      widget.adisyon ? 'Güncelle' : "Ekle",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
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
            _buildStepModeSection(),
            _buildOptionsSection(),
            const SizedBox(height: 15),
            _buildDescriptionSection(),
            const SizedBox(height: 500), // Bottom padding
          ],
        ),
      ),
    );
  }
}
