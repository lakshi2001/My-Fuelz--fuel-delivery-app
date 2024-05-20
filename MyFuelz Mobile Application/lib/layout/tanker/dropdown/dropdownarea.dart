import 'package:flutter/material.dart';
import 'package:myfuelz/globle/constants.dart';

class DropDownAreaTextfield extends StatelessWidget {
  final List<String>? areaNames;
  final Function handleAreaSelect;
  final String hintText;
  final String dropdownValue;

  const DropDownAreaTextfield({
    Key? key,
    required this.areaNames,
    required this.handleAreaSelect,
    required this.hintText,
    required this.dropdownValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double relativeWidth = size.width / Constants.referenceWidth;
    double relativeHeight = size.height / Constants.referenceHeight;

    List<DropdownMenuItem<String>> dropdownItems = [
      const DropdownMenuItem<String>(
        value: 'No option',
        child: Text('No option'),
      ),
      if (areaNames != null)
        ...areaNames!.toSet().toList().map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }),
    ];

    return Container(
      width: relativeWidth *400,
       height: relativeHeight * 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0x6022242E),
          width: 1.0,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          padding: EdgeInsets.only(
            right: relativeWidth * 28,
            left: relativeWidth * 20,
          ),
          alignedDropdown: true,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFFFFFFF),
            ),
            child: DropdownButton<String>(
              value: dropdownValue == "No option" ? null : dropdownValue,
              onChanged: (String? value) {
                handleAreaSelect(value);
              },
              hint: const Text("Select an Area"),
              items: dropdownItems,
              style: const TextStyle(
                color: Color(0x6022242E), // Change text color
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0x6022242E), // Change arrow color
              ),
              dropdownColor: Colors.white, // Change dropdown background color
            ),
          ),
        ),
      ),
    );
  }
}
