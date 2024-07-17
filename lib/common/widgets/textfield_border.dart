import 'package:flutter/material.dart';
import 'package:keeper_of_projects/data.dart';

OutlineInputBorder focusedBorder() {
  return const OutlineInputBorder(
    borderSide: BorderSide(
      color: Pallete.primary,
      width: 4,
    ),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );
}

OutlineInputBorder enabledBorder() {
  return OutlineInputBorder(
    borderSide: BorderSide(
      color: Pallete.text,
      width: 2,
    ),
    borderRadius: const BorderRadius.all(Radius.circular(10)),
  );
}
