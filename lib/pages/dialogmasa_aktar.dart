import 'package:animation_wrappers/animations/faded_scale_animation.dart';
import 'package:flutter/material.dart';

import '../config/settings.dart';
import '../features/data/models/dataGet/table_item_model.dart';
import '../features/data/models/dataPost/adisyon_model.dart';
import '../pages/cuper_alert.dart';
import '../core/routes/routes.dart';

class MyDialogMasaAktar extends StatefulWidget {
  const MyDialogMasaAktar({super.key});

  @override
  MyDialogMasaAktarState createState() => MyDialogMasaAktarState();
}

bool login = true;

// Future<Future<String?>> _asyncInputDialog(BuildContext context) async {
//   String sampleText = '';
//   return showDialog<String>(
//     context: context,
//     barrierDismissible:
//         false, // dialog is dismissible with a tap on the barrier
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Masaya Aktarıldı'),
//         content: Row(
//           children: <Widget>[
//             Expanded(
//               child: TextField(
//                 autofocus: true,
//                 decoration: const InputDecoration(
//                   labelText: 'Aktarım Notu',
//                   hintText: 'boş geçebilirsiniz',
//                 ),
//                 onChanged: (value) {
//                   sampleText = value;
//                 },
//               ),
//             ),
//           ],
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: const Text('Tamam'),
//             onPressed: () {
//               Navigator.of(context).pop(sampleText);
//             },
//           ),
//         ],
//       );
//     },
//   );
// }

class MyDialogMasaAktarState extends State<MyDialogMasaAktar>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    verigetir();
  }

  Future<void> verigetir() async {
    List<TableItemModel> cartItems;

    cartItems = await getTableItemAll();

    setState(() {
      masaitem = cartItems;

      login = false;
    });
  }

  Future<bool> adisyonMasaAktar(int id, int yeniid) async {
    bool stringFuture = false;
    try {
      stringFuture = await replaceSiparisAdisyon(id, yeniid);
    } catch (error) {
      if (mounted) {
        CuperAlert.show(
          context: context,
          destructive: true,
          title: 'Hata',
          content: 'Masa Aktarma Hatası!\n$error',
        );
      }
    }
    return stringFuture;
  }

  late List<TableItemModel> masaitem = [];

  final TextEditingController myController = TextEditingController();
  String masaadi = "";
  int masaid = 0;

  Future<bool> adisyonMasadon() async {
    setState(() {
      Navigator.pushNamed(
        context,
        PageRoutes.tableSelectionPage,
        arguments: {
          'garsonId': Settings.getGarsonId(),
          'garsonadi': Settings.getGarsonAdi(),
        },
      );
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{})
            as Map;

    if (arguments.length > 1) {
      masaid = arguments['masaid'];
      masaadi = arguments['masaadi'];
    }

    final title = '$masaadi Aktarılacak Masa Listesi';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: ListView.builder(
          itemCount: masaitem.length,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 2,
                horizontal: 2,
              ),
              leading: FadedScaleAnimation(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FadedScaleAnimation(
                    child: Icon(
                      masaitem[index].masaAcik == true
                          ? Icons.table_restaurant
                          : Icons.table_restaurant,
                      size: 50,
                      color: masaitem[index].masaAcik == true
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                ),
              ),
              title: Text('${masaitem[index].adi}'),
              trailing: TextButton(
                child: const Text('Buraya Aktar'),
                onPressed: () async {
                  bool stringFuture = false;
                  stringFuture = await adisyonMasaAktar(
                    masaid,
                    masaitem[index].id!,
                  );

                  if (stringFuture == true) {
                    await adisyonMasadon();
                  }
                },
              ),
              subtitle: Text(
                masaitem[index].masaAcik == true ? 'Masa Açık' : 'Kapalı',
              ),
            );
          },
        ),
      ),
    );
  }
}
