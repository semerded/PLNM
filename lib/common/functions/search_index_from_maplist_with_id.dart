import 'package:collection/collection.dart';

int searchIndexFromMaplist(Map map, List mapList) {
  for (int index = 0; index < mapList.length; index++) {
    if (map["id"] == mapList[index]["id"]) {
      return index;
    }
  }
  return -1;
}
