import 'package:keeper_of_projects/backend/data.dart';

bool checkCategoryValidity(category) {
  return categoryDataContent!.contains(category);
}
