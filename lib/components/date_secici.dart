import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/config.dart';

class DateSecici extends StatelessWidget {
  final Function(DateTime)? degisim;
  final Function? temizle;
  final DateTime? maxtarih;
  final String? tarih;
  final CupertinoDatePickerMode? mode;
  final bool? saat24, showsaat;
  final int? maxyil, minyil;
  final Color? color;

  const DateSecici({
    super.key,
    this.tarih,
    this.mode = CupertinoDatePickerMode.date,
    this.saat24 = true,
    this.showsaat = false,
    this.degisim,
    this.temizle,
    this.maxyil,
    this.minyil = 1,
    this.maxtarih,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    DateTime? sondate;
    if (tarih != '' && tarih != 'null' && tarih != null) {
      sondate = DateTime.parse(tarih.toString());
    }

    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey, width: 1.0),
          bottom: BorderSide(color: Colors.grey, width: 1.0),
          left: BorderSide(color: Colors.grey, width: 1.0),
          right: BorderSide(color: Colors.grey, width: 1.0),
        ),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: CupertinoButton(
        onPressed: () => Config.showDialogCoportion(
          context,
          CupertinoDatePicker(
            initialDateTime: sondate,
            mode: mode!,
            maximumYear: maxyil,
            minimumYear: minyil!,
            maximumDate: maxtarih,
            use24hFormat: saat24!,
            onDateTimeChanged: degisim!,
          ),
        ),
        child: SizedBox(
          height: 18,
          child: Row(
            children: [
              Expanded(
                flex: 8,
                child: (sondate != null)
                    ? (!showsaat!)
                          ? Text(
                              '${sondate.day}.${sondate.month}.${sondate.year}',
                              style: TextStyle(fontSize: 16.0, color: color),
                            )
                          : Text(
                              '${sondate.day}.${sondate.month}.${sondate.year} ${sondate.hour}:${sondate.minute}',
                              style: TextStyle(fontSize: 16.0, color: color),
                            )
                    : const Text(
                        'Tarih seç',
                        style: TextStyle(color: Colors.blue),
                      ),
              ),
              Expanded(
                flex: 1,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (sondate != null) {
                      temizle!();
                    }
                  },
                  child: Icon(
                    CupertinoIcons.clear_circled_solid,
                    color: Colors.grey.shade800,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
