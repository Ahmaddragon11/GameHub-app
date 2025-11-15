import 'package:flutter/material.dart';

class GameModel {
  final String id;
  final String name;
  final String nameEn;
  final String description;
  final String descriptionEn;
  final String iconPath;
  final String route;
  final Color color;
  int highScore;

  GameModel({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.description,
    required this.descriptionEn,
    required this.iconPath,
    required this.route,
    required this.color,
    this.highScore = 0,
  });

  GameModel copyWith({
    String? id,
    String? name,
    String? nameEn,
    String? description,
    String? descriptionEn,
    String? iconPath,
    String? route,
    Color? color,
    int? highScore,
  }) {
    return GameModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      description: description ?? this.description,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      iconPath: iconPath ?? this.iconPath,
      route: route ?? this.route,
      color: color ?? this.color,
      highScore: highScore ?? this.highScore,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameEn': nameEn,
      'description': description,
      'descriptionEn': descriptionEn,
      'iconPath': iconPath,
      'route': route,
      'color': color.value,
      'highScore': highScore,
    };
  }

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'],
      name: json['name'],
      nameEn: json['nameEn'],
      description: json['description'],
      descriptionEn: json['descriptionEn'],
      iconPath: json['iconPath'],
      route: json['route'],
      color: Color(json['color']),
      highScore: json['highScore'],
    );
  }
}
