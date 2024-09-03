void filterCategoryToggle(List filter) {
  if (filter.every((priority) => !priority)) {
    for (int i = 0; i < filter.length; i++) {
      filter[i] = true;
    }
  } else {
    for (int i = 0; i < filter.length; i++) {
      filter[i] = false;
    }
  }
}
