import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'is_wide_screen_provider.g.dart';

@riverpod
bool isWideScreen(IsWideScreenRef ref, MediaQueryData mqData) {
  return mqData.size.width > 600;
}
