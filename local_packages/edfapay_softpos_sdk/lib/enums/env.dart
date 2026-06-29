// ignore_for_file: constant_identifier_names, non_constant_identifier_names
enum Env {
  DEVELOPMENT,
  STAGING,
  SANDBOX,
  PRODUCTION;

  static Env get DEFAULT => DEVELOPMENT;
}
