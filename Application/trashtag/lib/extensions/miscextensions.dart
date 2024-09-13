// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

extension IconExtensions on Icon {
  Icon color(Color color) {
    return Icon(
      this.icon,
      color: color,
      size: this.size,
    );
  }
}

extension IconDataExtensions on IconData {
  Icon toIcon({Color? color, double? size}) {
    return Icon(
      this,
      color: color,
      size: size ?? 20,
    );
  }
}

extension WidgetMarginExtensions on Widget {
  Center center() {
    return Center(child: this);
  }

  Expanded expanded({int flex = 1}) {
    return Expanded(
      flex: flex,
      child: this,
    );
  }

  Widget onClick(Function onClick) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onClick as void Function()?,
        child: this,
      ),
    );
  }

  Widget clip(double radius) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: this,
    );
  }

  SizedBox limitSize([double? w, double? h]) {
    return SizedBox(
      height: h,
      width: w,
      child: this,
    );
  }

  Container maxConstrain([double? w, double? h]) {
    return Container(
      constraints: (w != null && h != null)
          ? BoxConstraints(maxHeight: h, maxWidth: w)
          : (w != null)
              ? BoxConstraints(maxWidth: w)
              : (h != null)
                  ? BoxConstraints(maxHeight: h)
                  : null,
      child: this,
    );
  }

  Container minConstrain([double? w, double? h]) {
    return Container(
      constraints: (w != null && h != null)
          ? BoxConstraints(minHeight: h, minWidth: w)
          : (w != null)
              ? BoxConstraints(minWidth: w)
              : (h != null)
                  ? BoxConstraints(minHeight: h)
                  : null,
      child: this,
    );
  }

  Container translate(double x, double y, double z) {
    return Container(
      transform: Matrix4.translationValues(x, y, z),
      child: this,
    );
  }

  Widget scale(double scale) {
    return Transform.scale(
      scale: scale,
      child: this,
    );
  }

  Container addUniformMargin(double value) => Container(
        margin: EdgeInsets.all(value),
        child: this,
      );
  Container addHorizontalMargin(double value) => Container(
        margin: EdgeInsets.symmetric(horizontal: value),
        child: this,
      );
  Container addVerticalMargin(double value) => Container(
        margin: EdgeInsets.symmetric(vertical: value),
        child: this,
      );
  Container addTopMargin(double value) => Container(
        margin: EdgeInsets.only(top: value),
        child: this,
      );

  Container addBottomMargin(double value) => Container(
        margin: EdgeInsets.only(bottom: value),
        child: this,
      );

  Container addRightMargin(double value) => Container(
        margin: EdgeInsets.only(right: value),
        child: this,
      );

  Container addLeftMargin(double value) => Container(
        margin: EdgeInsets.only(left: value),
        child: this,
      );

  Container addCustomMargin({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) =>
      Container(
        margin: EdgeInsets.only(
          top: top ?? 0,
          bottom: bottom ?? 0,
          left: left ?? 0,
          right: right ?? 0,
        ),
        child: this,
      );

  Widget floatRight(
    Widget child, {
    double width = 10.0,
    // MainAxisAlignment alignment = MainAxisAlignment.start,
  }) {
    return Wrap(
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [this, SizedBox(width: width), child],
    );
  }

  Widget floatLeft(
    Widget child, {
    double width = 10.0,
    // MainAxisAlignment alignment = MainAxisAlignment.start,
  }) {
    return Wrap(
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        child,
        SizedBox(width: width),
        this,
      ],
    );
  }

  Column chain(
    List<Widget> children, {
    CrossAxisAlignment? crossAlignment,
    MainAxisAlignment? mainAlignment,
    double spacing = 10,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAlignment ?? CrossAxisAlignment.start,
      mainAxisAlignment: mainAlignment ?? MainAxisAlignment.start,
      children: [
        this,
        ...children,
      ].addVerticalSpacing(spacing),
    );
  }
}

extension WidgetPaddingExtensions on Widget {
  Padding addUniformPadding(double value) => Padding(
        padding: EdgeInsets.all(value),
        child: this,
      );
  Padding addHorizontalPadding(double value) => Padding(
        padding: EdgeInsets.symmetric(horizontal: value),
        child: this,
      );
  Padding addVerticalPadding(double value) => Padding(
        padding: EdgeInsets.symmetric(vertical: value),
        child: this,
      );
  Padding addTopPadding(double value) => Padding(
        padding: EdgeInsets.only(top: value),
        child: this,
      );

  Padding addBottomPadding(double value) => Padding(
        padding: EdgeInsets.only(bottom: value),
        child: this,
      );

  Padding addRightPadding(double value) => Padding(
        padding: EdgeInsets.only(right: value),
        child: this,
      );

  Padding addLeftPadding(double value) => Padding(
        padding: EdgeInsets.only(left: value),
        child: this,
      );

  Padding addCustomPadding({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) =>
      Padding(
        padding: EdgeInsets.only(
          top: top ?? 0,
          bottom: bottom ?? 0,
          left: left ?? 0,
          right: right ?? 0,
        ),
        child: this,
      );

  RotatedBox rotate(int quarterTurns) {
    return RotatedBox(
      quarterTurns: quarterTurns,
      child: this,
    );
  }

  Transform rotateDegrees(double degrees) {
    return Transform.rotate(
      angle: degrees * (3.1415926535 / 180),
      child: this,
    );
  }

  AnimatedBuilder attachNotifier(dynamic notifier) {
    return AnimatedBuilder(
      animation: notifier,
      builder: (_, __) {
        return this;
      },
    );
  }
}

extension DynEx<T> on dynamic {
  T ternary(T compvalue, T truthy, [T? falsy]) {
    return this == compvalue ? truthy : falsy ?? this;
  }
}

extension StringExtensions on String {
  int? toInt() => int.tryParse(this);
  double? toDouble() => double.tryParse(this);

  symmetricTrim(int length) {
    return this.substring(length, this.length - length);
  }

  String capitalize() {
    if (this.isEmpty) return this;
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }

  String reverse() {
    return this.runes.toList().reversed.join();
  }
}

extension ListExtensions on List {
  int count(x) {
    return this.map((e) => e == x ? 1 : 0).reduce((x, y) => x + y);
  }

  T? findWhere<T>(bool Function(T) condition) {
    List x = this.where((e) => condition(e)).toList();
    if (x.isEmpty) return null;
    return x.first;
  }

  T? getFirstOrNull<T>() {
    if (this.isEmpty) return null;
    return this.first;
  }

  // 0 1 2 3 4 => 5
  //[1,3,4,5,9]
  //getNth(4)
  T? getNthOrNull<T>(int n) {
    if (this.isEmpty) return null;
    if (n >= this.length) return null;
    return this[n];
  }

  T? getLastOrNull<T>() {
    if (this.isEmpty) return null;
    return this.last;
  }

  bool get containsDuplicates {
    return (this.toSet().length < this.length);
  }

  void insertInPlace<T>(int i, T el) {
    if (this.getNthOrNull(i) == null) {
      this.insert(i, el);
    } else {
      this[i] = el;
    }
  }

  List<List<dynamic>> zip(List x) {
    int minLength = this.length < x.length ? this.length : x.length;
    List<List<dynamic>> zipped = [];

    for (int i = 0; i < minLength; i++) {
      zipped.add([this[i], x[i]]);
    }

    return zipped;
  }
}

extension ListWidgetExtensions on List<Widget> {
  List<Widget> addVerticalSpacing(double height) {
    if (this.isEmpty || this.length == 1) return this;
    List<Widget> newList = [];
    for (var e in this) {
      newList.add(e);
      if (e != this.last) {
        newList.add(SizedBox(
          height: height,
        ));
      }
    }

    return newList;
  }

  List<Widget> addHorizontalSpacing(double width) {
    if (this.isEmpty || this.length == 1) return this;
    List<Widget> newList = [];

    for (var e in this) {
      newList.add(e);
      if (e != this.last) {
        newList.add(SizedBox(
          width: width,
        ));
      }
    }

    return newList;
  }
}

extension IntExtensions on int {
  String numericPad({int? width}) {
    return this.toString().padLeft(width ?? 2, '0');
  }
}

extension DateTimeExtensions on DateTime {
  getDateString() {
    return "${this.day}/${this.month}/${this.year}";
  }
}

extension WidgetMeasureExtension on Widget {
  getSize([BoxConstraints constraints = const BoxConstraints()]) {
    final PipelineOwner pipelineOwner = PipelineOwner();
    final _MeasurementView rootView =
        pipelineOwner.rootNode = _MeasurementView(constraints);
    final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());
    final RenderObjectToWidgetElement<RenderBox> element =
        RenderObjectToWidgetAdapter<RenderBox>(
      container: rootView,
      debugShortDescription: '[root]',
      child: this,
    ).attachToRenderTree(buildOwner);
    try {
      rootView.scheduleInitialLayout();
      pipelineOwner.flushLayout();
      return rootView.size;
    } finally {
      // Clean up.
      element
          .update(RenderObjectToWidgetAdapter<RenderBox>(container: rootView));
      buildOwner.finalizeTree();
    }
  }
}

class _MeasurementView extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  final BoxConstraints boxConstraints;
  _MeasurementView(this.boxConstraints);

  @override
  void performLayout() {
    assert(child != null);
    child!.layout(boxConstraints, parentUsesSize: true);
    size = child!.size;
  }

  @override
  void debugAssertDoesMeetConstraints() => true;
}

extension CustomStringOperators on String {
  String operator |(String x) {
    return this.isEmpty ? x : this;
  }

  bool containsAny(List<String> options) {
    return options.any((e) => this.contains(e));
  }
}
