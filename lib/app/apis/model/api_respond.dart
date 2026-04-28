// ignore_for_file: public_member_api_docs, sort_constructors_first

class ApiResponsModel<T> {
  int? statusCode;
  String? message = '';
  String? error;
  T? data;
  int? count;
  NextCursor? nextCursor;

  ApiResponsModel({
    this.statusCode,
    this.message = '',
    this.error,
    this.data,
    this.nextCursor,
    this.count,
  });

  ApiResponsModel<T> copyWith({
    int? statusCode,
    String? message,
    String? error,
    NextCursor? nextCursor,
    int? count,
  }) => ApiResponsModel(
    statusCode: statusCode ?? this.statusCode,
    message: message ?? this.message,
    error: error ?? this.error,
    nextCursor: nextCursor ?? this.nextCursor,
    count: count ?? this.count,
  );

  factory ApiResponsModel.fromJson(Map<String, dynamic> json) {
    return ApiResponsModel<T>(
      statusCode: json["statusCode"],
      message: json["message"]?.toString() ?? '',
      error: json["error"]?.toString(),
      nextCursor: json["nextCursor"] == null
          ? null
          : NextCursor.fromJson(Map<String, dynamic>.from(json["nextCursor"])),
      count: json["count"],
    );
  }
  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "error": error,
    "nextCursor": nextCursor?.toJson(),
    "count": count,
  };

  @override
  String toString() {
    return 'ApiResponsModel(statusCode: $statusCode, message: $message, error: $error, data: $data, nextCursor:$nextCursor, count:$count)';
  }

  @override
  bool operator ==(covariant ApiResponsModel<T> other) {
    if (identical(this, other)) return true;

    return other.statusCode == statusCode &&
        other.message == message &&
        other.error == error;
  }

  @override
  int get hashCode {
    return statusCode.hashCode ^ message.hashCode ^ error.hashCode;
  }
}

class NextCursor {
  NextCursor({required this.value, required this.id});

  final String? value;
  final String? id;

  NextCursor copyWith({String? value, String? id}) {
    return NextCursor(value: value ?? this.value, id: id ?? this.id);
  }

  factory NextCursor.fromJson(Map<String, dynamic> json) {
    return NextCursor(value: json["value"], id: json["id"]);
  }

  Map<String, dynamic> toJson() => {"value": value, "id": id};

  @override
  String toString() {
    return "$value, $id, ";
  }
}
