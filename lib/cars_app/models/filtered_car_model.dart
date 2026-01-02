class FilteredCarModel {
  int? id;
  String? carName;
  String? carModel;
  int? price;
  bool? isAvailable;
  String? officeName;

  FilteredCarModel({
    this.id,
    this.carName,
    this.carModel,
    this.price,
    this.isAvailable,
    this.officeName,
  });

  FilteredCarModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    carName = json['carName'];
    carModel = json['carModel'];
    price = json['price'];
    isAvailable = json['isAvailable'];
    officeName = json['officeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['carName'] = carName;
    data['carModel'] = carModel;
    data['price'] = price;
    data['isAvailable'] = isAvailable;
    data['officeName'] = officeName;
    return data;
  }
}
