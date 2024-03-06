enum Currency {
  USD, GBP, CAD, NZD, AUD, EUR, JPY, CHF, NONE;

  static Currency fromString(String string) {
    if (string == "-") {
      return Currency.NONE;
    } else {
      return Currency.values.byName(string);
    }
  }

  @override
  String toString() {
    if (this == Currency.NONE){
      return "-";
    } else {
      return name;
    }
  }
}