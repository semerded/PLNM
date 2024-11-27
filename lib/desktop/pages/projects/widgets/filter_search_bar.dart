import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/functions/filter/filter_category_toggle.dart';
import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';
import 'package:keeper_of_projects/common/functions/filter/reset_filter.dart';
import 'package:keeper_of_projects/common/functions/filter/widgets/menu_items_header.dart';
import 'package:keeper_of_projects/common/widgets/base/icon.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';

typedef OnUpdated = void Function();

class FilterSearchBar extends StatefulWidget {
  final TextEditingController filterController;
  final FocusNode searchBarFocusNode;
  final OnUpdated onUpdated;
  const FilterSearchBar({
    super.key,
    required this.filterController,
    required this.searchBarFocusNode,
    required this.onUpdated,
  });

  @override
  State<FilterSearchBar> createState() => _FilterSearchBarState();
}

class _FilterSearchBarState extends State<FilterSearchBar> {
  final FocusNode _buttonFocusNode = FocusNode();
  final List<String> ddb_sortBy = ["Created (Latest)", "Created (Oldest)", "Priority (Highest)", "Priority (Lowest)", "Progress (Most)", "Progress (Least)", "Size (Biggest)", "Size (Smallest)"];
  late String ddb_sortBy_value;

  @override
  void initState() {
    super.initState();
    ddb_sortBy_value = ddb_sortBy.first;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: MenuAnchor(
            style: MenuStyle(backgroundColor: WidgetStatePropertyAll(Palette.box3)),
            childFocusNode: _buttonFocusNode,
            menuChildren: () {
              List<Widget> menuItems = [];
              menuItems.add(
                MenuItemsHeader(
                  text: "Priorities",
                  onClick: () {
                    setState(() {
                      filterCategoryToggle(priorityFilter);
                    });
                  },
                  anyFilterEnabled: priorityFilter.every((priority) => !priority), //? reverse bool to only enable all when nothing is enabled, otherwise disable if any (not all) are enabled
                ),
              );
              for (int i = 0; i < projectPriorities.length; i++) {
                menuItems.add(
                  CheckboxMenuButton(
                    closeOnActivate: false,
                    value: priorityFilter[i],
                    onChanged: (bool? value) {
                      setState(() {
                        priorityFilter[i] = !priorityFilter[i];
                      });
                    },
                    child: AdaptiveText(projectPriorities.keys.toList()[i]),
                  ),
                );
              }
              menuItems.add(
                MenuItemsHeader(
                  text: "Categories",
                  onClick: () {
                    setState(() {
                      bool updateTo = categoryFilter.values.every((value) => !value);
                      categoryFilter.updateAll((category, value) => value = updateTo);
                    });
                  },
                  anyFilterEnabled: categoryFilter.values.every((category) => !category),
                ),
              );
              for (String category in categoryFilter.keys) {
                menuItems.add(
                  CheckboxMenuButton(
                    closeOnActivate: false,
                    value: categoryFilter[category],
                    onChanged: (bool? value) {
                      setState(() {
                        categoryFilter[category] = !categoryFilter[category]!;
                      });
                    },
                    child: AdaptiveText(category),
                  ),
                );
              }
              return menuItems;
            }(),
            builder: (BuildContext context, MenuController controller, Widget? child) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Palette.box1),
                focusNode: _buttonFocusNode,
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                child: AdaptiveText('Filter'),
              );
            },
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              resetFilter();
              widget.filterController.clear();
            });
          },
          style: IconButton.styleFrom(backgroundColor: Colors.red),
          tooltip: "Remove All Filters",
          icon: AdaptiveIcon(Icons.filter_alt_off),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Container(
              color: Palette.box1,
              child: DropdownButton<String>(
                padding: const EdgeInsets.only(left: 7, right: 7),
                elevation: 15,
                isExpanded: true,
                dropdownColor: Palette.box3,
                value: ddb_sortBy_value,
                items: ddb_sortBy.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: AdaptiveText(
                      value,
                      overflow: TextOverflow.fade,
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    ddb_sortBy_value = value!;
                  });
                },
              ),
            ),
          ),
        ),
        CircleAvatar(
          radius: 20,
          backgroundColor: searchBarActive ? Palette.primary : Palette.box1,
          child: IconButton(
            color: searchBarActive ? Palette.box1 : Palette.primary,
            onPressed: () {
              setState(() {
                searchBarActive = !searchBarActive;
                searchBarActive ? FocusScope.of(context).requestFocus(widget.searchBarFocusNode) : FocusManager.instance.primaryFocus?.unfocus();
              });
              widget.onUpdated();
            },
            icon: const Icon(Icons.search),
          ),
        ),
      ],
    );
  }
}
