class PropertyResponedModel {
  PropertyResponedModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.size,
    required this.agentFee,
    required this.inspectionFee,
    required this.images,
    required this.location,
    required this.owner,
    required this.likes,
    required this.unlikes,
    required this.likesCount,
    required this.unlikesCount,
    required this.comments,
    required this.views,
    required this.verificationStatus,
    required this.isAvailable,
    required this.isSold,
    required this.priorityLevel,
    required this.slug,
    required this.trendingScore,
    required this.furnishingStatus,
    required this.amenities,
    required this.commentsCount,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? title;
  final String? description;
  final String? type;
  final String? status;
  final int? price;
  final int? bedrooms;
  final int? bathrooms;
  final int? size;
  final int? agentFee;
  final int? inspectionFee;
  final List<Image1> images;
  final Location? location;
  final Owner? owner;
  final List<String> likes;
  final List<dynamic> unlikes;
  final int? likesCount;
  final int? unlikesCount;
  final List<dynamic> comments;
  final int? views;
  final String? verificationStatus;
  final bool? isAvailable;
  final bool? isSold;
  final int? priorityLevel;
  final String? slug;
  final int? trendingScore;
  final String? furnishingStatus;
  final List<dynamic> amenities;
  final int? commentsCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PropertyResponedModel copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    String? status,
    int? price,
    int? bedrooms,
    int? bathrooms,
    int? size,
    int? agentFee,
    int? inspectionFee,
    List<Image1>? images,
    Location? location,
    Owner? owner,
    List<String>? likes,
    List<dynamic>? unlikes,
    int? likesCount,
    int? unlikesCount,
    List<dynamic>? comments,
    int? views,
    String? verificationStatus,
    bool? isAvailable,
    bool? isSold,
    int? priorityLevel,
    String? slug,
    int? trendingScore,
    String? furnishingStatus,
    List<dynamic>? amenities,
    int? commentsCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PropertyResponedModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      price: price ?? this.price,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      size: size ?? this.size,
      agentFee: agentFee ?? this.agentFee,
      inspectionFee: inspectionFee ?? this.inspectionFee,
      images: images ?? this.images,
      location: location ?? this.location,
      owner: owner ?? this.owner,
      likes: likes ?? this.likes,
      unlikes: unlikes ?? this.unlikes,
      likesCount: likesCount ?? this.likesCount,
      unlikesCount: unlikesCount ?? this.unlikesCount,
      comments: comments ?? this.comments,
      views: views ?? this.views,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      isAvailable: isAvailable ?? this.isAvailable,
      isSold: isSold ?? this.isSold,
      priorityLevel: priorityLevel ?? this.priorityLevel,
      slug: slug ?? this.slug,
      trendingScore: trendingScore ?? this.trendingScore,
      furnishingStatus: furnishingStatus ?? this.furnishingStatus,
      amenities: amenities ?? this.amenities,
      commentsCount: commentsCount ?? this.commentsCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory PropertyResponedModel.fromJson(Map<String, dynamic> json) {
    return PropertyResponedModel(
      id: json["_id"],
      title: json["title"],
      description: json["description"],
      type: json["type"],
      status: json["status"],
      price: json["price"],
      bedrooms: json["bedrooms"],
      bathrooms: json["bathrooms"],
      size: json["size"],
      agentFee: json["agentFee"],
      inspectionFee: json["inspectionFee"],
      images: json["images"] == null
          ? []
          : List<Image1>.from(json["images"]!.map((x) => Image1.fromJson(x))),
      location: json["location"] == null
          ? null
          : Location.fromJson(json["location"]),
      owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
      likes: json["likes"] == null
          ? []
          : List<String>.from(json["likes"]!.map((x) => x)),
      unlikes: json["unlikes"] == null
          ? []
          : List<dynamic>.from(json["unlikes"]!.map((x) => x)),
      likesCount: json["likesCount"],
      unlikesCount: json["unlikesCount"],
      comments: json["comments"] == null
          ? []
          : List<dynamic>.from(json["comments"]!.map((x) => x)),
      views: json["views"],
      verificationStatus: json["verificationStatus"],
      isAvailable: json["isAvailable"],
      isSold: json["isSold"],
      priorityLevel: json["priorityLevel"],
      slug: json["slug"],
      trendingScore: json["trendingScore"],
      furnishingStatus: json["furnishingStatus"],
      amenities: json["amenities"] == null
          ? []
          : List<dynamic>.from(json["amenities"]!.map((x) => x)),
      commentsCount: json["commentsCount"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
    "type": type,
    "status": status,
    "price": price,
    "bedrooms": bedrooms,
    "bathrooms": bathrooms,
    "size": size,
    "agentFee": agentFee,
    "inspectionFee": inspectionFee,
    "images": images.map((x) => x.toJson()).toList(),
    "location": location?.toJson(),
    "owner": owner?.toJson(),
    "likes": likes.map((x) => x).toList(),
    "unlikes": unlikes.map((x) => x).toList(),
    "likesCount": likesCount,
    "unlikesCount": unlikesCount,
    "comments": comments.map((x) => x).toList(),
    "views": views,
    "verificationStatus": verificationStatus,
    "isAvailable": isAvailable,
    "isSold": isSold,
    "priorityLevel": priorityLevel,
    "slug": slug,
    "trendingScore": trendingScore,
    "furnishingStatus": furnishingStatus,
    "amenities": amenities.map((x) => x).toList(),
    "commentsCount": commentsCount,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };

  @override
  String toString() {
    return "$id, $title, $description, $type, $status, $price, $bedrooms, $bathrooms, $size, $agentFee, $inspectionFee, $images, $location, $owner, $likes, $unlikes, $likesCount, $unlikesCount, $comments, $views, $verificationStatus, $isAvailable, $isSold, $priorityLevel, $slug, $trendingScore, $furnishingStatus, $amenities, $commentsCount, $createdAt, $updatedAt, ";
  }
}

class Image1 {
  Image1({required this.url, required this.publicId, required this.id});

  final String? url;
  final String? publicId;
  final String? id;

  Image1 copyWith({String? url, String? publicId, String? id}) {
    return Image1(
      url: url ?? this.url,
      publicId: publicId ?? this.publicId,
      id: id ?? this.id,
    );
  }

  factory Image1.fromJson(Map<String, dynamic> json) {
    return Image1(
      url: json["url"],
      publicId: json["public_id"],
      id: json["_id"],
    );
  }

  Map<String, dynamic> toJson() => {
    "url": url,
    "public_id": publicId,
    "_id": id,
  };

  @override
  String toString() {
    return "$url, $publicId, $id, ";
  }
}

class Location {
  Location({
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.coordinates,
  });

  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final Coordinates? coordinates;

  Location copyWith({
    String? address,
    String? city,
    String? state,
    String? country,
    Coordinates? coordinates,
  }) {
    return Location(
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      coordinates: coordinates ?? this.coordinates,
    );
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      address: json["address"],
      city: json["city"],
      state: json["state"],
      country: json["country"],
      coordinates: json["coordinates"] == null
          ? null
          : Coordinates.fromJson(json["coordinates"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "address": address,
    "city": city,
    "state": state,
    "country": country,
    "coordinates": coordinates?.toJson(),
  };

  @override
  String toString() {
    return "$address, $city, $state, $country, $coordinates, ";
  }
}

class Coordinates {
  Coordinates({required this.type, required this.coordinates});

  final String? type;
  final List<double> coordinates;

  Coordinates copyWith({String? type, List<double>? coordinates}) {
    return Coordinates(
      type: type ?? this.type,
      coordinates: coordinates ?? this.coordinates,
    );
  }

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      type: json["type"],
      coordinates: json["coordinates"] == null
          ? []
          : List<double>.from(json["coordinates"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": coordinates.map((x) => x).toList(),
  };

  @override
  String toString() {
    return "$type, $coordinates, ";
  }
}

class Owner {
  Owner({
    required this.id,
    required this.user,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.city,
    required this.address,
    required this.nationality,
    required this.cacNumber,
    required this.companyName,
    required this.yearsOfExperience,
    required this.description,
    required this.status,
    required this.nin,
    required this.ninSlipUrl,
    required this.selfieUrl,
    required this.cacDocumentUrl,
    required this.bvn,
    required this.isAgreement,
    required this.kycStatus,
    required this.verificationData,
    required this.savedProperties,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final User? user;
  final String? firstName;
  final String? lastName;
  final DateTime? dateOfBirth;
  final String? city;
  final String? address;
  final String? nationality;
  final String? cacNumber;
  final String? companyName;
  final int? yearsOfExperience;
  final String? description;
  final String? status;
  final String? nin;
  final CacDocumentUrl? ninSlipUrl;
  final CacDocumentUrl? selfieUrl;
  final CacDocumentUrl? cacDocumentUrl;
  final dynamic bvn;
  final bool? isAgreement;
  final KycStatus? kycStatus;
  final VerificationData? verificationData;
  final List<String> savedProperties;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Owner copyWith({
    String? id,
    User? user,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? city,
    String? address,
    String? nationality,
    String? cacNumber,
    String? companyName,
    int? yearsOfExperience,
    String? description,
    String? status,
    String? nin,
    CacDocumentUrl? ninSlipUrl,
    CacDocumentUrl? selfieUrl,
    CacDocumentUrl? cacDocumentUrl,
    dynamic bvn,
    bool? isAgreement,
    KycStatus? kycStatus,
    VerificationData? verificationData,
    List<String>? savedProperties,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return Owner(
      id: id ?? this.id,
      user: user ?? this.user,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      city: city ?? this.city,
      address: address ?? this.address,
      nationality: nationality ?? this.nationality,
      cacNumber: cacNumber ?? this.cacNumber,
      companyName: companyName ?? this.companyName,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      description: description ?? this.description,
      status: status ?? this.status,
      nin: nin ?? this.nin,
      ninSlipUrl: ninSlipUrl ?? this.ninSlipUrl,
      selfieUrl: selfieUrl ?? this.selfieUrl,
      cacDocumentUrl: cacDocumentUrl ?? this.cacDocumentUrl,
      bvn: bvn ?? this.bvn,
      isAgreement: isAgreement ?? this.isAgreement,
      kycStatus: kycStatus ?? this.kycStatus,
      verificationData: verificationData ?? this.verificationData,
      savedProperties: savedProperties ?? this.savedProperties,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json["_id"],
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      firstName: json["firstName"],
      lastName: json["lastName"],
      dateOfBirth: DateTime.tryParse(json["dateOfBirth"] ?? ""),
      city: json["city"],
      address: json["address"],
      nationality: json["nationality"],
      cacNumber: json["cacNumber"],
      companyName: json["companyName"],
      yearsOfExperience: json["yearsOfExperience"],
      description: json["description"],
      status: json["status"],
      nin: json["nin"],
      ninSlipUrl: json["ninSlipUrl"] == null
          ? null
          : CacDocumentUrl.fromJson(json["ninSlipUrl"]),
      selfieUrl: json["selfieUrl"] == null
          ? null
          : CacDocumentUrl.fromJson(json["selfieUrl"]),
      cacDocumentUrl: json["cacDocumentUrl"] == null
          ? null
          : CacDocumentUrl.fromJson(json["cacDocumentUrl"]),
      bvn: json["bvn"],
      isAgreement: json["isAgreement"],
      kycStatus: json["kycStatus"] == null
          ? null
          : KycStatus.fromJson(json["kycStatus"]),
      verificationData: json["verificationData"] == null
          ? null
          : VerificationData.fromJson(json["verificationData"]),
      savedProperties: json["savedProperties"] == null
          ? []
          : List<String>.from(json["savedProperties"]!.map((x) => x)),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user?.toJson(),
    "firstName": firstName,
    "lastName": lastName,
    "dateOfBirth": dateOfBirth?.toIso8601String(),
    "city": city,
    "address": address,
    "nationality": nationality,
    "cacNumber": cacNumber,
    "companyName": companyName,
    "yearsOfExperience": yearsOfExperience,
    "description": description,
    "status": status,
    "nin": nin,
    "ninSlipUrl": ninSlipUrl?.toJson(),
    "selfieUrl": selfieUrl?.toJson(),
    "cacDocumentUrl": cacDocumentUrl?.toJson(),
    "bvn": bvn,
    "isAgreement": isAgreement,
    "kycStatus": kycStatus?.toJson(),
    "verificationData": verificationData?.toJson(),
    "savedProperties": savedProperties.map((x) => x).toList(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };

  @override
  String toString() {
    return "$id, $user, $firstName, $lastName, $dateOfBirth, $city, $address, $nationality, $cacNumber, $companyName, $yearsOfExperience, $description, $status, $nin, $ninSlipUrl, $selfieUrl, $cacDocumentUrl, $bvn, $isAgreement, $kycStatus, $verificationData, $savedProperties, $createdAt, $updatedAt, $v, ";
  }
}

class CacDocumentUrl {
  CacDocumentUrl({required this.url, required this.publicId});

  final String? url;
  final String? publicId;

  CacDocumentUrl copyWith({String? url, String? publicId}) {
    return CacDocumentUrl(
      url: url ?? this.url,
      publicId: publicId ?? this.publicId,
    );
  }

  factory CacDocumentUrl.fromJson(Map<String, dynamic> json) {
    return CacDocumentUrl(url: json["url"], publicId: json["public_id"]);
  }

  Map<String, dynamic> toJson() => {"url": url, "public_id": publicId};

  @override
  String toString() {
    return "$url, $publicId, ";
  }
}

class KycStatus {
  KycStatus({
    required this.ninVerified,
    required this.cacVerified,
    required this.bvnVerified,
    required this.livenessVerified,
  });

  final bool? ninVerified;
  final bool? cacVerified;
  final bool? bvnVerified;
  final bool? livenessVerified;

  KycStatus copyWith({
    bool? ninVerified,
    bool? cacVerified,
    bool? bvnVerified,
    bool? livenessVerified,
  }) {
    return KycStatus(
      ninVerified: ninVerified ?? this.ninVerified,
      cacVerified: cacVerified ?? this.cacVerified,
      bvnVerified: bvnVerified ?? this.bvnVerified,
      livenessVerified: livenessVerified ?? this.livenessVerified,
    );
  }

  factory KycStatus.fromJson(Map<String, dynamic> json) {
    return KycStatus(
      ninVerified: json["ninVerified"],
      cacVerified: json["cacVerified"],
      bvnVerified: json["bvnVerified"],
      livenessVerified: json["livenessVerified"],
    );
  }

  Map<String, dynamic> toJson() => {
    "ninVerified": ninVerified,
    "cacVerified": cacVerified,
    "bvnVerified": bvnVerified,
    "livenessVerified": livenessVerified,
  };

  @override
  String toString() {
    return "$ninVerified, $cacVerified, $bvnVerified, $livenessVerified, ";
  }
}

class User {
  User({
    required this.id,
    required this.fullName,
    required this.profileImage,
    required this.phoneNumber,
    required this.roles,
  });

  final String? id;
  final String? fullName;
  final CacDocumentUrl? profileImage;
  final String? phoneNumber;
  final List<String> roles;

  User copyWith({
    String? id,
    String? fullName,
    CacDocumentUrl? profileImage,
    String? phoneNumber,
    List<String>? roles,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      profileImage: profileImage ?? this.profileImage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      roles: roles ?? this.roles,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["_id"],
      fullName: json["fullName"],
      profileImage: json["profileImage"] == null
          ? null
          : CacDocumentUrl.fromJson(json["profileImage"]),
      phoneNumber: json["phoneNumber"],
      roles: json["roles"] == null
          ? []
          : List<String>.from(json["roles"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "fullName": fullName,
    "profileImage": profileImage?.toJson(),
    "phoneNumber": phoneNumber,
    "roles": roles.map((x) => x).toList(),
  };

  @override
  String toString() {
    return "$id, $fullName, $profileImage, $phoneNumber, $roles, ";
  }
}

class VerificationData {
  VerificationData({
    required this.nin,
    required this.cac,
    required this.liveness,
    required this.bvn,
  });

  final dynamic nin;
  final dynamic cac;
  final dynamic liveness;
  final dynamic bvn;

  VerificationData copyWith({
    dynamic nin,
    dynamic cac,
    dynamic liveness,
    dynamic bvn,
  }) {
    return VerificationData(
      nin: nin ?? this.nin,
      cac: cac ?? this.cac,
      liveness: liveness ?? this.liveness,
      bvn: bvn ?? this.bvn,
    );
  }

  factory VerificationData.fromJson(Map<String, dynamic> json) {
    return VerificationData(
      nin: json["nin"],
      cac: json["cac"],
      liveness: json["liveness"],
      bvn: json["bvn"],
    );
  }

  Map<String, dynamic> toJson() => {
    "nin": nin,
    "cac": cac,
    "liveness": liveness,
    "bvn": bvn,
  };

  @override
  String toString() {
    return "$nin, $cac, $liveness, $bvn, ";
  }
}
