import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/filter/widgets/menu_items_header.dart';
import 'package:keeper_of_projects/common/pages/category_editor/category_editor_page.dart';
import 'package:keeper_of_projects/common/widgets/base/icon.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/typedef.dart';

class SelectCategory extends StatefulWidget {
  final List initChosenCategories;
  final OnUpdatedL onChosen;
  const SelectCategory({
    super.key,
    required this.initChosenCategories,
    required this.onChosen,
  });

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  final FocusNode _buttonFocusNode = FocusNode();
  final ListEquality<String> _listEquality = const ListEquality<String>();

  late List<String> chosenCategories;

  @override
  void initState() {
    super.initState();
    chosenCategories = List<String>.from(widget.initChosenCategories);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: MenuAnchor(
        onClose: () => widget.onChosen(chosenCategories),
        style: MenuStyle(backgroundColor: WidgetStatePropertyAll(Palette.box3)),
        childFocusNode: _buttonFocusNode,
        menuChildren: () {
          List<Widget> menuItems = [];
          menuItems.add(
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Palette.box1),
                    onPressed: () {
                      setState(() {
                        if (_listEquality.equals(chosenCategories, categoryDataContent)) {
                          chosenCategories.clear();
                        } else {
                          chosenCategories = List<String>.from(categoryDataContent!);
                        }
                      });
                    },
                    child: AdaptiveText(_listEquality.equals(chosenCategories, categoryDataContent) ? "Disable All" : "Enable All "),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Palette.box1),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<bool>(
                          builder: (context) => const CategoryEditorPage(),
                        ),
                      ).then((callback) {
                        setState(() {});
                      });
                    },
                    child: AdaptiveText("Edit categories"),
                  ),
                ),
              ],
            ),
          );
          for (int i = 0; i < categoryDataContent!.length; i++) {
            menuItems.add(
              Theme(
                data: ThemeData(
                  checkboxTheme: CheckboxThemeData(
                    fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Palette.primary;
                      }
                      return Palette.box1;
                    }),
                  ),
                ),
                child: CheckboxMenuButton(
                  closeOnActivate: false,
                  value: chosenCategories.contains(categoryDataContent![i]),
                  child: AdaptiveText(categoryDataContent![i]),
                  onChanged: (bool? value) {
                    if (value == null) return;
                    setState(() {
                      if (value) {
                        chosenCategories.add(categoryDataContent![i]);
                      } else {
                        chosenCategories.remove(categoryDataContent![i]);
                      }
                    });
                  },
                ),
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
            iconAlignment: IconAlignment.end,
            child: Row(
              children: [
                const Spacer(),
                AdaptiveText('Categories'),
                const Spacer(
                  flex: 2,
                ),
                chosenCategories.isEmpty
                    ? const Icon(
                        Icons.category_outlined,
                        color: Colors.yellow,
                      )
                    : AdaptiveIcon(Icons.category),
                const SizedBox(width: 4),
                AdaptiveText(chosenCategories.length.toString()),
                const Spacer()
              ],
            ),
          );
        },
      ),
    );

    // return Padding(
    //                 padding: const EdgeInsets.all(4),
    //                 child: Container(
    //                   color: Palette.box1,
    //                   child: DropdownButton<String>(
    //                     padding: const EdgeInsets.only(left: 7, right: 7),
    //                     isExpanded: true,
    //                     elevation: 15,
    //                     dropdownColor: Palette.box3,
    //                     value: ,
    //                     items: categories.map<DropdownMenuItem<String>>((String value) {
    //                       return DropdownMenuItem(
    //                         value: value,
    //                         child: Padding(
    //                           padding: const EdgeInsets.only(left: 8),
    //                           child: AdaptiveText(
    //                             value,
    //                             overflow: TextOverflow.fade,
    //                             fontStyle: value == ddb_catgegoryDefaultText ? FontStyle.italic : FontStyle.normal,
    //                           ),
    //                         ),
    //                       );
    //                     }).toList(),
    //                     onChanged: (String? value) {
    //                       setState(() {
    //                         newProject["category"] = ddb_category_value = value!;
    //                         validCategory = value != ddb_catgegoryDefaultText;
    //                         validate();
    //                       });
    //                     },
    //                   ),
    //                 ),
    //               ),;
  }
}
