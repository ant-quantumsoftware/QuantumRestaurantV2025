import 'package:flutter/material.dart';

import '../../data/models/dataPost/adisyon_model.dart';

class MyDialogAciklama extends StatefulWidget {
  final String adi;
  final int detayid;

  const MyDialogAciklama({super.key, required this.adi, required this.detayid});
  @override
  MyDialogAciklamaState createState() => MyDialogAciklamaState();
}

class MyDialogAciklamaState extends State<MyDialogAciklama> {
  @override
  void initState() {
    super.initState();
  }

  final TextEditingController myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    myController.text = "";
    return AlertDialog(
      title: const Text(
        "Açıklama Girişi",
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        height: 45.0,
        child: Container(
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.all(7),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 79, 133, 81),
            border: Border.all(
              color: Colors.grey, // Set border color
              width: 1.0,
            ), // Set border width
            borderRadius: const BorderRadius.all(
              Radius.circular(2.0),
            ), // Set rounded corner radius
            // Make rounded corner of border
          ),
          child: Text(
            widget.adi,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Orta
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(7),
                  width: 200,
                  alignment: Alignment.center,
                  child: TextField(
                    controller: myController,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                //SizedBox(width: 55),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: const Text(
                "Kapat",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            const SizedBox(width: 30),
            TextButton(
              child: const Text(
                "Tamam",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                // Malzeme İlgili Sepete At Todo

                int id = widget.detayid;

                var model = AdisyonModel(
                  id: id,
                  malzemeid: 0,
                  fiyatd: 0,
                  adi: "",
                  ozellik1: myController.text,
                  ozellik2: "",
                  ozellik3: "",
                  masaid: 0,
                );

                sendSiparisAciklama(model);

                Navigator.pop(context, true);
              },
            ),
          ],
        ),
      ],
    );
  }
}
