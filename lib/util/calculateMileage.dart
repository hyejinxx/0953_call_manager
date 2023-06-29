int calMileage(int amount) {
  // 5000원 단위로 계산
  int price = (amount ~/ 5000) * 5000;
  if (price > 200000) {
    return 200000;
  } else if (price > 100000) {
    int price = (amount ~/ 50000) * 50000;
    return price;
  } else {
    return price;
  }
}
