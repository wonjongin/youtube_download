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
  History.formMap(Map<String, dynamic> map){
    id = map['id'];
    thumbNail = map['thumbNail'];
    date = map['date'];
    size = map['size'];
    path = map['path'];
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