import 'dart:math';

class RanKeyAssets {
  var upperAlphabets = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
  ];
  var digits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
}

class RandomKey {
  Set<String> usedReferenceNumbers = <String>{};

  Future<String> generateRandomProductCode() async {
    var ranAssets = RanKeyAssets();

    String first2Digits = '';
    String first2Alphabets = '';

    for (int i = 0; i < 2; i++) {
      first2Alphabets +=
      ranAssets.upperAlphabets[Random.secure().nextInt(ranAssets.upperAlphabets.length)];
      first2Digits +=
      ranAssets.digits[Random.secure().nextInt(ranAssets.digits.length)];
    }

    String productCodeRandom =
        '$first2Alphabets$first2Digits${DateTime.now().microsecondsSinceEpoch.toString().substring(8, 10)}';

    // Ensure uniqueness
    while (usedReferenceNumbers.contains(productCodeRandom)) {
      // Regenerate if the reference number is already used
      for (int i = 0; i < 2; i++) {
        first2Alphabets +=
        ranAssets.upperAlphabets[Random.secure().nextInt(ranAssets.upperAlphabets.length)];
        first2Digits +=
        ranAssets.digits[Random.secure().nextInt(ranAssets.digits.length)];
      }
      productCodeRandom =
      '$first2Alphabets$first2Digits${DateTime.now().microsecondsSinceEpoch.toString().substring(8, 10)}';
    }

    usedReferenceNumbers.add(productCodeRandom);

    return productCodeRandom;
  }
}
