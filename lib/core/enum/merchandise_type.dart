enum MerchandiseType {
  food,
  accessory;

  String toJson() => name;
  static MerchandiseType fromJson(String json) => values.byName(json);
}
