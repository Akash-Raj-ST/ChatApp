/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Msg type in your schema. */
@immutable
class Msg {
  final String? _message;
  final bool? _mine;
  final TemporalDateTime? _time;

  String? get message {
    return _message;
  }
  
  bool? get mine {
    return _mine;
  }
  
  TemporalDateTime? get time {
    return _time;
  }
  
  const Msg._internal({message, mine, time}): _message = message, _mine = mine, _time = time;
  
  factory Msg({String? message, bool? mine, TemporalDateTime? time}) {
    return Msg._internal(
      message: message,
      mine: mine,
      time: time);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Msg &&
      _message == other._message &&
      _mine == other._mine &&
      _time == other._time;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Msg {");
    buffer.write("message=" + "$_message" + ", ");
    buffer.write("mine=" + (_mine != null ? _mine!.toString() : "null") + ", ");
    buffer.write("time=" + (_time != null ? _time!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Msg copyWith({String? message, bool? mine, TemporalDateTime? time}) {
    return Msg._internal(
      message: message ?? this.message,
      mine: mine ?? this.mine,
      time: time ?? this.time);
  }
  
  Msg.fromJson(Map<String, dynamic> json)  
    : _message = json['message'],
      _mine = json['mine'],
      _time = json['time'] != null ? TemporalDateTime.fromString(json['time']) : null;
  
  Map<String, dynamic> toJson() => {
    'message': _message, 'mine': _mine, 'time': _time?.format()
  };
  
  Map<String, Object?> toMap() => {
    'message': _message, 'mine': _mine, 'time': _time
  };

  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Msg";
    modelSchemaDefinition.pluralName = "Msgs";
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'message',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'mine',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'time',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
  });
}