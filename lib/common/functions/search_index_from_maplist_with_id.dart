int searchIndexFromMaplist(Map map, List mapList) {
  for (int index = 0; index < mapList.length; index++) {
    if (map["id"] == mapList[index]["id"]) {
      return index;
    }
  }
  return -1;
}

int searchIndexFromId(String id, List mapList) {
  for (int index = 0; index < mapList.length; index++) {
    if (id == mapList[index]["id"]) {
      return index;
    }
  }
  return -1;
}
