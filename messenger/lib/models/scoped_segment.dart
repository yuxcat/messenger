import 'package:flutter/cupertino.dart';

class ScopedSegments extends ChangeNotifier {
  ScopedSegmentsModel ssmodel = ScopedSegmentsModel();
  onChange(value) {
    ssmodel.groupValue = value;
    notifyListeners();
  }
}

class ScopedSegmentsModel {
  int groupValue = 0;
}
