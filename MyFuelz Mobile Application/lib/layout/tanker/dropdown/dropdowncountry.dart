import 'package:flutter/material.dart';
import 'package:myfuelz/globle/constants.dart';





class DropDownCountryTextfield extends StatelessWidget {
  final List<String>? countryNames;
  final Function handleMakeSelect;
  final String hintText;
  final String dropdownvalue;

   // ignore: use_key_in_widget_constructors
   const DropDownCountryTextfield({
    Key? key,
    required this.countryNames,
    required this.handleMakeSelect,
    required this.hintText,
    required this.dropdownvalue,
  });

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

    return Container(
      width: relativeWidth * 368,
      height: relativeHeight * 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          // Add border properties here
          color: Colors.grey, // Border color
          width: 1.0, // Border width
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          padding: EdgeInsets.only(
            right: relativeWidth * 21,
            left: relativeWidth * 25,
          ),
          alignedDropdown: true,
          child: DropdownButton<String>(
            value: dropdownvalue == "No option" ? null : dropdownvalue,
            onChanged: (String? value) {
              handleMakeSelect(value);
            },
            hint: Text("Select a Country"),
            items: dropdownItems,
          ),
        ),
      ),
    );
  }
}
