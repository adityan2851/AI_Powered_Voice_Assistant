import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

class MyRadioList {
  final List<MyRadio> radios;
  MyRadioList({
    this.radios,
  });

  MyRadioList copyWith({
    List<MyRadio> radios,
  }) {
    return MyRadioList(
      radios: radios ?? this.radios,
    );
  }

  MyRadioList merge(MyRadioList model) {
    return MyRadioList(
      radios: model.radios ?? this.radios,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'radios': radios?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory MyRadioList.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return MyRadioList(
      radios: List<MyRadio>.from(map['radios']?.map((x) => MyRadio.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory MyRadioList.fromJson(String source) => MyRadioList.fromMap(json.decode(source));

  @override
  String toString() => 'MyRadioList(radios: $radios)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    final listEquals = const DeepCollectionEquality().equals;
  
    return o is MyRadioList &&
      listEquals(o.radios, radios);
  }

  @override
  int get hashCode => radios.hashCode;
}

class MyRadio {
  final int id;
  final int order;
  final String name;
  final String tagline;
  final String color;
  final String desc;
  final String url;
  final String category;
  final String icon;
  final String image;
  final String language;
  MyRadio({
    this.id,
    this.order,
    this.name,
    this.tagline,
    this.color,
    this.desc,
    this.url,
    this.category,
    this.icon,
    this.image,
    this.language,
  });
  

  MyRadio copyWith({
    int id,
    int order,
    String name,
    String tagline,
    String color,
    String desc,
    String url,
    String category,
    String icon,
    String image,
    String language,
  }) {
    return MyRadio(
      id: id ?? this.id,
      order: order ?? this.order,
      name: name ?? this.name,
      tagline: tagline ?? this.tagline,
      color: color ?? this.color,
      desc: desc ?? this.desc,
      url: url ?? this.url,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      image: image ?? this.image,
      language: language ?? this.language,
    );
  }

  MyRadio merge(MyRadio model) {
    return MyRadio(
      id: model.id ?? this.id,
      order: model.order ?? this.order,
      name: model.name ?? this.name,
      tagline: model.tagline ?? this.tagline,
      color: model.color ?? this.color,
      desc: model.desc ?? this.desc,
      url: model.url ?? this.url,
      category: model.category ?? this.category,
      icon: model.icon ?? this.icon,
      image: model.image ?? this.image,
      language: model.language ?? this.language,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order': order,
      'name': name,
      'tagline': tagline,
      'color': color,
      'desc': desc,
      'url': url,
      'category': category,
      'icon': icon,
      'image': image,
      'language': language,
    };
  }

  factory MyRadio.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return MyRadio(
      id: map['id'],
      order: map['order'],
      name: map['name'],
      tagline: map['tagline'],
      color: map['color'],
      desc: map['desc'],
      url: map['url'],
      category: map['category'],
      icon: map['icon'],
      image: map['image'],
      language: map['language'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MyRadio.fromJson(String source) => MyRadio.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MyRadio(id: $id, order: $order, name: $name, tagline: $tagline, color: $color, desc: $desc, url: $url, category: $category, icon: $icon, image: $image, language: $language)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is MyRadio &&
      o.id == id &&
      o.order == order &&
      o.name == name &&
      o.tagline == tagline &&
      o.color == color &&
      o.desc == desc &&
      o.url == url &&
      o.category == category &&
      o.icon == icon &&
      o.image == image &&
      o.language == language;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      order.hashCode ^
      name.hashCode ^
      tagline.hashCode ^
      color.hashCode ^
      desc.hashCode ^
      url.hashCode ^
      category.hashCode ^
      icon.hashCode ^
      image.hashCode ^
      language.hashCode;
  }
}
