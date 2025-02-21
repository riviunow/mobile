DateTime parseUtcDateTime(String dateTimeString) {
  return DateTime.utc(
    int.parse(dateTimeString.substring(0, 4)),
    int.parse(dateTimeString.substring(5, 7)),
    int.parse(dateTimeString.substring(8, 10)),
    int.parse(dateTimeString.substring(11, 13)),
    int.parse(dateTimeString.substring(14, 16)),
    int.parse(dateTimeString.substring(17, 19)),
  );
}
