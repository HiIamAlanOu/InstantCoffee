import 'package:flutter/material.dart';
import 'package:readr_app/models/SectionList.dart';

class SectionsStateProvider extends ChangeNotifier {
  SectionList _updatedSection = new SectionList();

  void sortSections(SectionList currentSections) {
    currentSections.sections.sort((a, b) => a.order.compareTo(b.order));
    for (int i = 0; i < currentSections.sections.length; i++) {
      currentSections.sections[i].setOrder(i);
    }
    _updatedSection = currentSections;
    notifyListeners();
  }

  SectionList get updatedSection => _updatedSection;
}