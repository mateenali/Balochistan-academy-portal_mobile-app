import 'package:flutter/material.dart';
import 'theme.dart';

class Subject {
  final String key;
  final String name;
  final String urdu;
  final IconData icon;
  final Color c1;
  final Color c2;
  final int lessons;
  final int progress; // 0..100
  const Subject(this.key, this.name, this.urdu, this.icon, this.c1, this.c2, this.lessons, this.progress);
}

const List<Subject> kSubjects = [
  Subject('math', 'Mathematics', 'ریاضی', Icons.functions, AppColors.indigo400, AppColors.indigo600, 24, 42),
  Subject('phy', 'Physics', 'طبیعیات', Icons.bubble_chart, AppColors.sky, AppColors.sky2, 18, 30),
  Subject('chem', 'Chemistry', 'کیمیا', Icons.science, AppColors.teal400, AppColors.teal600, 20, 64),
  Subject('bio', 'Biology', 'حیاتیات', Icons.spa, AppColors.lime, AppColors.lime2, 16, 22),
  Subject('eng', 'English', 'انگریزی', Icons.menu_book, AppColors.apricot, AppColors.apricot2, 22, 52),
  Subject('urdu', 'Urdu', 'اردو', Icons.edit_note, AppColors.rose, AppColors.rose2, 19, 38),
  Subject('cs', 'Computer Sci', 'کمپیوٹر', Icons.psychology, AppColors.violet, AppColors.violet2, 14, 16),
  Subject('isl', 'Islamiat', 'اسلامیات', Icons.star_rounded, AppColors.cyan, AppColors.cyan2, 12, 70),
];
