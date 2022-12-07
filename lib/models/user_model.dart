import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  final String name;
  final String profilePic;
  final String banner;
  final String uid;
  final bool isGuest;
  final int karma;
  final List<String> awards;
  UserModel({
    required this.name,
    required this.profilePic,
    required this.banner,
    required this.uid,
    required this.isGuest,
    required this.karma,
    required this.awards,
  });

  UserModel copyWith({
    String? name,
    String? profilePic,
    String? banner,
    String? uid,
    bool? isGuest,
    int? karma,
    List<String>? awards,
  }) {
    return UserModel(
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      banner: banner ?? this.banner,
      uid: uid ?? this.uid,
      isGuest: isGuest ?? this.isGuest,
      karma: karma ?? this.karma,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePic': profilePic,
      'banner': banner,
      'uid': uid,
      'isGuest': isGuest,
      'karma': karma,
      'awards': awards,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic>? map) {
    return UserModel(
      name: map?['name'] ?? '',
      profilePic: map?['profilePic'] ?? '',
      banner: map?['banner'] ?? '',
      uid: map?['uid'] ?? '',
      isGuest: map?['isGuest'] ?? '',
      karma: map?['karma'] ?? '',
      awards: List<String>.from(map?['awards'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(name: $name, profilePic: $profilePic, banner: $banner, uid: $uid, isGuest: $isGuest, karma: $karma, awards: $awards)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.name == name &&
        other.profilePic == profilePic &&
        other.banner == banner &&
        other.uid == uid &&
        other.isGuest == isGuest &&
        other.karma == karma &&
        listEquals(other.awards, awards);
  }

  @override
  int get hashCode {
    return name.hashCode ^ profilePic.hashCode ^ banner.hashCode ^ uid.hashCode ^ isGuest.hashCode ^ karma.hashCode ^ awards.hashCode;
  }
}
