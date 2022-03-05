library thumbnails;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:youtube_search_app/data/model/common/model_common.dart';
import 'package:youtube_search_app/data/model/serializer/serializers.dart';

part 'thumbnails.g.dart';

abstract class Thumbnails implements Built<Thumbnails, ThumbnailsBuilder>{
  @BuiltValueField(wireName: 'default')
  Thumbnail get default_;
  Thumbnail get medium;
  Thumbnail get high;

  Thumbnails._();

  factory Thumbnails([updates(ThumbnailsBuilder b)]) = _$Thumbnails;

  String toJson(){
    return json.decode(serializers.serializeWith(Thumbnails.serializer, this));
  }

  static Thumbnails fromJson(String jsonString){
    return serializers.deserializeWith(Thumbnails.serializer, json.decode(jsonString));
  }

  static Serializer<Thumbnails> get serializer => _$thumbnailsSerializer;
}