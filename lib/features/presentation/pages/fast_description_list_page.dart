import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/fast_description_entity.dart';
import '../module/fast_description_notifier.dart';

class FastDescriptionListPage extends ConsumerStatefulWidget {
  const FastDescriptionListPage({super.key});

  @override
  ConsumerState<FastDescriptionListPage> createState() =>
      _FastDescriptionListPageState();
}

class _FastDescriptionListPageState
    extends ConsumerState<FastDescriptionListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshDescriptions();
    });
  }

  Future<void> _refreshDescriptions() async {
    final localeCode = mounted
        ? Localizations.localeOf(context).languageCode
        : null;
    await ref
        .read(fastDescriptionNotifierProvider.notifier)
        .getDescriptionsForProduct(null, localeCode: localeCode);
  }

  Future<void> _showAddDescriptionDialog() async {
    final ingredientController = TextEditingController();
    final descriptionController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hazır Açıklama Ekle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: ingredientController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Etiket (opsiyonel)',
                    hintText: 'Örn: Az Tuzlu',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Açıklama',
                    hintText: 'Açıklama metnini girin',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () async {
                final description = descriptionController.text.trim();
                final ingredient = ingredientController.text.trim();

                if (description.isEmpty) {
                  return;
                }

                final localeCode = Localizations.localeOf(context).languageCode;

                await ref
                    .read(fastDescriptionNotifierProvider.notifier)
                    .saveDescription(
                      FastDescriptionEntity(
                        productId: null,
                        ingredientId: null,
                        ingredientName: ingredient.isEmpty ? null : ingredient,
                        description: description,
                        localeCode: localeCode,
                        updatedAt: DateTime.now(),
                      ),
                    );

                if (!context.mounted) return;
                Navigator.pop(context);
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fastDescriptionNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Hazır Açıklamalar')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDescriptionDialog,
        icon: const Icon(Icons.add),
        label: const Text('Açıklama Ekle'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDescriptions,
        child: Builder(
          builder: (context) {
            if (state.isLoading && state.descriptions.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.descriptions.isEmpty) {
              return const Center(
                child: Text('Henüz kayıtlı açıklama bulunmuyor.'),
              );
            }

            final items = [...state.descriptions]
              ..sort((a, b) {
                final aDate =
                    a.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
                final bDate =
                    b.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
                return bDate.compareTo(aDate);
              });

            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = items[index];

                return Card(
                  child: ListTile(
                    title: Text(item.description),
                    subtitle:
                        (item.ingredientName == null ||
                            item.ingredientName!.isEmpty)
                        ? null
                        : Text(item.ingredientName!),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () async {
                        await ref
                            .read(fastDescriptionNotifierProvider.notifier)
                            .deleteDescription(
                              id: item.id,
                              productId: item.productId,
                              ingredientId: item.ingredientId,
                              localeCode: item.localeCode,
                            );
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
