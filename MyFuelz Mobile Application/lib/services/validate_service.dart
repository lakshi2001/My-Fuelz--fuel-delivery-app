class ValidateService {
  String? isEmptyField(String value) {
    if (value.isEmpty) {
      return 'Required';
    }
    return null;
  }

  String? postalCode(String value) {
    String? isEmpty = isEmptyField(value);
    int len = value.length;
    String pattern = r'^\d{5}$';
    RegExp regExp = RegExp(pattern);

    if (isEmpty != null) {
      return isEmpty;
    } else if (!regExp.hasMatch(value)) {
      return "Invalid postal code";
    }
    return null;
  }

  String? validatePhoneNumber(String value) {
    String pattern = r'^\+94\d{9}$';
    RegExp regExp = RegExp(pattern);

    if (value.isEmpty) {
      return 'Please enter a mobile number';
    } else if (!value.startsWith('+94')) {
      return 'Please enter a number starting with +94';
    } else if (value.length != 12) {
      return 'Mobile number should be 12 characters long';
    } else if (!regExp.hasMatch(value)) {
      return 'Invalid mobile number';
    }
    return null;
  }

  String? validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    String? isEmpty = isEmptyField(value);

    if (isEmpty != null) {
      return isEmpty;
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.length < 8) {
      return "Must be more than 8 characters";
    }

    if (!password.contains(RegExp(r"[a-z]"))) {
      return "at least one lowercase character";
    }
    if (!password.contains(RegExp(r"[A-Z]"))) {
      return "at least one upper case character";
    }
    if (!password.contains(RegExp(r"[0-9]"))) {
      return "at least one Digit";
    }
    return null;
  }
}
