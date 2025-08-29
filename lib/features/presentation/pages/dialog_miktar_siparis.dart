import 'package:flutter/material.dart';

import '../../data/models/dataPost/adisyon_model.dart';
import '../pages/cuper_alert.dart';

class MyDialog extends StatefulWidget {
  final String adi;
  final String secenek1;
  final String secenek2;
  final String secenek3;
  final String secenek4;
  final String secenek5;
  final String secenek6;
  final int malzemeId;
  final int masaid;
  const MyDialog({
    super.key,
    required this.adi,
    required this.malzemeId,
    required this.masaid,
    required this.secenek1,
    required this.secenek2,
    required this.secenek3,
    required this.secenek4,
    required this.secenek5,
    required this.secenek6,
  });
  @override
  MyDialogState createState() => MyDialogState();
}

String aktifMiktarstr = "1.00";
double aktifmiktar = 1;

class MyDialogState extends State<MyDialog> {
  @override
  void initState() {
    super.initState();
    aktifmiktar = 1;
    aktifMiktarstr = "1";

    // Seçenekleri Doldur
    fruits.clear();
    _selectedFruits.clear();
    fruitsStr.clear();

    if (widget.secenek1 != "") {
      fruits.add(Text(widget.secenek1));
      fruitsStr.add(widget.secenek1);
      _selectedFruits.add(false);
    }

    if (widget.secenek2 != "") {
      fruits.add(Text(widget.secenek2));
      fruitsStr.add(widget.secenek2);
      _selectedFruits.add(false);
    }

    if (widget.secenek3 != "") {
      fruits.add(Text(widget.secenek3));
      fruitsStr.add(widget.secenek3);
      _selectedFruits.add(false);
    }
    if (widget.secenek4 != "") {
      fruits.add(Text(widget.secenek4));
      fruitsStr.add(widget.secenek4);
      _selectedFruits.add(false);
    }

    if (widget.secenek5 != "") {
      fruits.add(Text(widget.secenek5));
      fruitsStr.add(widget.secenek5);
      _selectedFruits.add(false);
    }

    if (widget.secenek6 != "") {
      fruits.add(Text(widget.secenek6));
      fruitsStr.add(widget.secenek6);
      _selectedFruits.add(false);
    }
  }

  void miktarGuncelle() {
    aktifMiktarstr = aktifmiktar.toString();
    myController.text = aktifMiktarstr;
  }

  final TextEditingController myController = TextEditingController();
  bool vertical = false;
  List<Widget> fruits = <Widget>[];

  List<String> fruitsStr = <String>[];

  final List<bool> _selectedFruits = <bool>[];
  String seciliOzellik = "";

  @override
  Widget build(BuildContext context) {
    myController.text = aktifMiktarstr;
    return AlertDialog(
      title: const Text(
        "Miktar Girisi",
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        height: 35.0,
        child: Container(
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
        Column(
          children: [
            const Text('Özellik Seçimi'),

            ToggleButtons(
              direction: vertical ? Axis.vertical : Axis.horizontal,
              onPressed: (int index) {
                setState(() {
                  // The button that is tapped is set to true, and the others to false.
                  for (int i = 0; i < _selectedFruits.length; i++) {
                    _selectedFruits[i] = i == index;
                  }

                  seciliOzellik = fruitsStr[index];
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: Colors.green[700],
              selectedColor: Colors.white,
              fillColor: Colors.green[200],
              color: Colors.green[700],
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 40.0,
              ),
              isSelected: _selectedFruits,
              children: fruits,
            ),
            const SizedBox(height: 10),

            // ToggleButtons with a multiple se
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Sol Kolon
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              aktifmiktar = aktifmiktar + 0.5;
                              miktarGuncelle();
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(9),
                            width: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              border: Border.all(
                                color: Colors.green, // Set border color
                                width: 1.0,
                              ), // Set border width
                              borderRadius: const BorderRadius.all(
                                Radius.circular(2.0),
                              ), // Set rounded corner radius
                              // Make rounded corner of border
                            ),
                            child: const Text(
                              '+0,5',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              aktifmiktar = aktifmiktar > 0.5
                                  ? aktifmiktar - 0.5
                                  : 0;
                              miktarGuncelle();
                            });

                            //showToastMessage("-");
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(9),
                            width: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.green, // Set border color
                                width: 1.0,
                              ), // Set border width
                              borderRadius: const BorderRadius.all(
                                Radius.circular(2.0),
                              ), // Set rounded corner radius
                              // Make rounded corner of border
                            ),
                            child: const Text(
                              '-0,5',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              aktifmiktar = 0.5;
                              miktarGuncelle();
                            });

                            //showToastMessage("-");
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(9),
                            width: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.green[300],
                              border: Border.all(
                                color: Colors.green, // Set border color
                                width: 1.0,
                              ), // Set border width
                              borderRadius: const BorderRadius.all(
                                Radius.circular(2.0),
                              ), // Set rounded corner radius
                              // Make rounded corner of border
                            ),
                            child: const Text(
                              '0,5',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Orta
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(2),
                          padding: const EdgeInsets.all(7),
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: Colors.green[300]),
                          child: TextField(
                            controller: myController,
                            readOnly: true,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        //SizedBox(width: 55),
                      ],
                    ),
                    // Sağ Kolon
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              aktifmiktar = aktifmiktar + 1;
                              miktarGuncelle();
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(9),
                            width: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              border: Border.all(
                                color: Colors.green, // Set border color
                                width: 1.0,
                              ), // Set border width
                              borderRadius: const BorderRadius.all(
                                Radius.circular(2.0),
                              ), // Set rounded corner radius
                              // Make rounded corner of border
                            ),
                            child: const Text(
                              '+1',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              aktifmiktar = aktifmiktar > 1
                                  ? aktifmiktar - 1
                                  : 0;
                              miktarGuncelle();
                            });

                            //showToastMessage("-");
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(9),
                            width: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.green, // Set border color
                                width: 1.0,
                              ), // Set border width
                              borderRadius: const BorderRadius.all(
                                Radius.circular(2.0),
                              ), // Set rounded corner radius
                              // Make rounded corner of border
                            ),
                            child: const Text(
                              '-1',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              aktifmiktar = 1;
                              miktarGuncelle();
                            });

                            //showToastMessage("-");
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(9),
                            width: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.green[300],
                              border: Border.all(
                                color: Colors.green, // Set border color
                                width: 1.0,
                              ), // Set border width
                              borderRadius: const BorderRadius.all(
                                Radius.circular(2.0),
                              ), // Set rounded corner radius
                              // Make rounded corner of border
                            ),
                            child: const Text(
                              '1',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                    Navigator.pop(context);
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
                  onPressed: () async {
                    // Malzeme İlgili Sepete At Todo

                    int malzemeidim = widget.malzemeId;
                    double miktarim = aktifmiktar;

                    var model = AdisyonModel(
                      id: 0,
                      kisisayisi: 1,
                      miktar: miktarim,
                      malzemeid: malzemeidim,
                      fiyatd: 0,
                      secenek: seciliOzellik,
                      ozellik1: "",
                      ozellik2: "",
                      ozellik3: "",
                      masaid: widget.masaid,
                    );

                    try {
                      Navigator.pop(context);
                      var kontrol = await sendSiparisAdisyon(model);
                      if (kontrol == true) {
                      } else {
                        if (context.mounted) {
                          CuperAlert.show(
                            context: context,
                            destructive: true,
                            title: 'Ürün Ekleme Hatası! ${widget.adi}',
                            content: 'Bağlantınızı Kontrol Ediniz!\n',
                          );
                        }
                      }
                    } on Exception catch (ex) {
                      String hata = ex.toString();
                      if (context.mounted) {
                        CuperAlert.show(
                          context: context,
                          destructive: true,
                          title: 'Servis Hatası!',
                          content: 'Bağlantınızı Kontrol Ediniz!\n$hata',
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
