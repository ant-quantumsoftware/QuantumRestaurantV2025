import 'package:flutter/material.dart';

import '../../data/models/dataPost/adisyon_model.dart';

class OrderDescriptionDialog extends StatefulWidget {
  final String name;
  final int detailId;

  const OrderDescriptionDialog({
    super.key,
    required this.name,
    required this.detailId,
  });

  @override
  OrderDescriptionDialogState createState() => OrderDescriptionDialogState();
}

class OrderDescriptionDialogState extends State<OrderDescriptionDialog> {
  final TextEditingController myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      title: Row(
        children: [
          Icon(
            Icons.description_outlined,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Siparis Aciklamasi',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              widget.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: myController,
            maxLines: 3,
            minLines: 2,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: 'Aciklama yazin...',
              filled: true,
              fillColor: theme.colorScheme.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.25),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('Kapat'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton(
                onPressed: () {
                  final model = AdisyonModel(
                    id: widget.detailId,
                    malzemeid: 0,
                    fiyatd: 0,
                    adi: '',
                    ozellikAciklama1: myController.text.trim(),
                    ozellikAciklama2: '',
                    ozellikAciklama3: '',
                    masaid: 0,
                  );

                  sendSiparisAciklama(model);
                  Navigator.pop(context, true);
                },
                child: const Text('Kaydet'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
