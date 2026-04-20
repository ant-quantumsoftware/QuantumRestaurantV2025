import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final tableCardThemeNotifierProvider =
    StateNotifierProvider<TableCardThemeNotifier, TableCardThemeState>((ref) {
      return TableCardThemeNotifier();
    });

class TableCardThemeState {
  final Color openTableColor;
  final Color closedTableColor;
  final Color billWrittenTableColor;
  final bool isLoaded;

  const TableCardThemeState({
    required this.openTableColor,
    required this.closedTableColor,
    required this.billWrittenTableColor,
    required this.isLoaded,
  });

  factory TableCardThemeState.defaults() {
    return const TableCardThemeState(
      openTableColor: Color(0xFF5A2020),
      closedTableColor: Color(0xFF1E3A2A),
      billWrittenTableColor: Color(0xFF5C3A10),
      isLoaded: false,
    );
  }

  TableCardThemeState copyWith({
    Color? openTableColor,
    Color? closedTableColor,
    Color? billWrittenTableColor,
    bool? isLoaded,
  }) {
    return TableCardThemeState(
      openTableColor: openTableColor ?? this.openTableColor,
      closedTableColor: closedTableColor ?? this.closedTableColor,
      billWrittenTableColor:
          billWrittenTableColor ?? this.billWrittenTableColor,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}

class TableCardThemeNotifier extends StateNotifier<TableCardThemeState> {
  TableCardThemeNotifier() : super(TableCardThemeState.defaults()) {
    _loadTheme();
  }

  static const String _openColorKey = 'table_card_open_color';
  static const String _closedColorKey = 'table_card_closed_color';
  static const String _billWrittenColorKey = 'table_card_bill_written_color';

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final openColorValue = prefs.getInt(_openColorKey);
    final closedColorValue = prefs.getInt(_closedColorKey);
    final billWrittenColorValue = prefs.getInt(_billWrittenColorKey);

    state = state.copyWith(
      openTableColor: openColorValue != null
          ? Color(openColorValue)
          : state.openTableColor,
      closedTableColor: closedColorValue != null
          ? Color(closedColorValue)
          : state.closedTableColor,
      billWrittenTableColor: billWrittenColorValue != null
          ? Color(billWrittenColorValue)
          : state.billWrittenTableColor,
      isLoaded: true,
    );
  }

  Future<void> setOpenTableColor(Color color) async {
    state = state.copyWith(openTableColor: color);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_openColorKey, color.toARGB32());
  }

  Future<void> setClosedTableColor(Color color) async {
    state = state.copyWith(closedTableColor: color);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_closedColorKey, color.toARGB32());
  }

  Future<void> setBillWrittenTableColor(Color color) async {
    state = state.copyWith(billWrittenTableColor: color);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_billWrittenColorKey, color.toARGB32());
  }
}
