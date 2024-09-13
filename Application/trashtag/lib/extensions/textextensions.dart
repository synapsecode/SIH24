import 'package:flutter/material.dart';

extension TextExtensions on Text {
  SelectableText makeSelectable() {
    return SelectableText(
      data!,
      style: style,
    );
  }

  Text size(double size) {
    return Text(
      data!,
      textAlign: textAlign,
      style: style?.copyWith(fontSize: size) ?? TextStyle(fontSize: size),
    );
  }

  Text color(Color color) {
    return Text(
      data!,
      textAlign: textAlign,
      style: style?.copyWith(color: color) ?? TextStyle(color: color),
    );
  }

  Text weight(FontWeight weight) {
    return Text(
      data!,
      textAlign: textAlign,
      style:
          style?.copyWith(fontWeight: weight) ?? TextStyle(fontWeight: weight),
    );
  }

  Text align(TextAlign alignment) {
    return Text(
      data!,
      style: style,
      textAlign: alignment,
    );
  }

  Text fontFamily(String family) {
    return Text(
      data!,
      style: style?.copyWith(fontFamily: family),
      textAlign: textAlign,
    );
  }

  Text setLineHeight(double ht) {
    return Text(
      data!,
      style: style?.copyWith(height: ht),
      textAlign: textAlign,
    );
  }

  Text letterSpacing(double spacing) {
    return Text(
      data!,
      style: style?.copyWith(letterSpacing: spacing),
      textAlign: textAlign,
    );
  }

  Text wrap([TextOverflow? overflow]) {
    return Text(
      data!,
      maxLines: 1,
      softWrap: false,
      overflow: overflow ?? TextOverflow.fade,
      style: style,
    );
  }
}
