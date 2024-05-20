import 'package:flutter/material.dart';
import 'package:myfuelz/globle/constants.dart';

class DropDownStateTextfield extends StatelessWidget {
  final List<String>? countryNames;
  final Function handleMakeSelect;
  final String hintText;
  final String dropdownvalue;

  const DropDownStateTextfield({
    Key? key,
    required this.countryNames,
    required this.handleMakeSelect,
    required this.hintText,
    required this.dropdownvalue,
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
      if (countryNames != null)
        ...countryNames!.toSet().toList().map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }),
    ];

    return Theme(
      data: ThemeData(
        primaryColor: Colors.red, // Change the primary color here
      ),
      child: Container(
        width: relativeWidth * 400,
        height: relativeHeight * 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(
          //   color: Color(0x6022242E),
          //   width: 1.0,
          // ),
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            padding: EdgeInsets.only(
              right: relativeWidth * 21,
              left: relativeWidth * 25,
            ),
            alignedDropdown: true,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFFFFFFF),
              ),
              child: DropdownButton<String>(
                value: dropdownvalue == "No option" ? null : dropdownvalue,
                onChanged: (String? value) {
                  handleMakeSelect(value);
                },
                hint: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "District",
                    style: TextStyle(color: Color(0x6022242E), fontSize: 16),
                  ),
                ),
                items: dropdownItems,
                style: const TextStyle(
                  color: Color(0x6022242E),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0x6022242E),
                ),
                dropdownColor: const Color(0xFFFFFFFF),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
