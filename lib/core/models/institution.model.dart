class InstitutionModel {
  InstitutionModel(
      {required this.idInstitution,
      required this.keyInstitution,
      required this.nameInstitution,
      required this.urlLogoInstitution});
  late final int idInstitution;
  late final String keyInstitution;
  late final String nameInstitution;
  late final String urlLogoInstitution;

  InstitutionModel.empty() {
    idInstitution = 0;
    keyInstitution = '';
    nameInstitution = '';
    urlLogoInstitution = '';
  }
  InstitutionModel.fromJson(Map<String, dynamic> json) {
    idInstitution = json['idInstitution'];
    keyInstitution = json['keyInstitution'];
    nameInstitution = json['nameInstitution'];
    urlLogoInstitution = json['urlLogoInstitution'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idInstitution'] = idInstitution;
    data['keyInstitution'] = keyInstitution;
    data['nameInstitution'] = nameInstitution;
    data['urlLogoInstitution'] = urlLogoInstitution;
    return data;
  }
}

class InstitutionAttributeModel {
  InstitutionAttributeModel(
      {required this.attributeName, required this.attributeValue});
  late String attributeName;
  late String attributeValue;

  InstitutionAttributeModel.empty() {
    attributeName = "";
    attributeValue = "";
  }

  InstitutionAttributeModel.fromJson(Map<String, dynamic> json) {
    attributeName = json['attributeName'];
    attributeValue = json['attributeValue'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['attributeName'] = attributeName;
    data['attributeValue'] = attributeValue;
    return data;
  }
}
