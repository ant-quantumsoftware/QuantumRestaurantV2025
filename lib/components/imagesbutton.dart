import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageButton extends StatefulWidget {
  final Function resimbase;
  final String imgurul;
  final int resimId;
  const ImageButton({
    super.key,
    required this.resimbase,
    required this.imgurul,
    required this.resimId,
  });

  @override
  State<ImageButton> createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageButton> {
  late Uint8List? _image;
  late String serverImage = "";
  final picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    serverImage = widget.imgurul;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        resimSecimler(0, (serverImage == "") ? false : true, widget.resimId);
      },
      child: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(15),
        child: Center(
          child:
              (serverImage == "")
                  ? (_image != null)
                      ? Image.memory(_image!)
                      : const Text(
                        "[ Resim Çek yada Yükle ]",
                        style: TextStyle(
                          color: Color.fromARGB(255, 11, 143, 219),
                        ),
                      )
                  : Image.network(serverImage),
        ),
      ),
    );
  }

  void resimSecimler(int index, bool durum, int resimId) {
    showCupertinoModalPopup<void>(
      context: context,
      builder:
          (BuildContext context) => CupertinoActionSheet(
            title: const Text('İspat Resim Yükle'),
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.of(context).pop();
                  choseImage(ImageSource.camera, index);
                },
                child: const Text('Kamera'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Galeriden Seç'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              isDestructiveAction: true,
              child: const Text("Vazgeç"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
    );
  }

  Future<void> choseImage(ImageSource source, int index) async {
    try {
      final pickedfile = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 600,
      );

      if (pickedfile != null) {
        var resim = await pickedfile.readAsBytes();
        widget.resimbase(resim);
        setState(() {
          _image = resim;
        });
      }
    } on Exception {
      throw Exception("Error on server");
    }
  }
}
