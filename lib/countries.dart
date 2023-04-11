class Country {
  String countryName;
  String countryCode;
  String langName;
  String countryCodeName;
  String langCode;

  Country(
      {this.countryName = 'Australia',
      this.countryCode = '61',
      this.langName = 'english',
      this.countryCodeName = 'au',
      this.langCode = 'en'});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
        countryName: json['country_name'] ?? "Unknown",
        countryCode: json['country_code'] ?? "Unknown",
        langName: json['lang_name'] ?? "Unknown",
        countryCodeName: json['country_code_name'] ?? "Unknown",
        langCode: json['lang_code'] ?? "Unknown");
  }
}
