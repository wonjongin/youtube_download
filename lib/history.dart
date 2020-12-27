import 'dart:convert';

class History {
  String id;
  String thumbNail; 
  String date; 
  String size; 
  String path;

  History({
    this.id,
    this.thumbNail,
    this.date,
    this.size,
    this.path,
  });
  History.fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.thumbNail = map['thumbNail'];
    this.date = map['date'];
    this.size = map['size'];
    this.path = map['path'];
  }
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['thumbNail'] = this.thumbNail;
    data['date'] = this.date;
    data['size'] = this.size;
    data['path'] = this.path;
    return data;
  }
}