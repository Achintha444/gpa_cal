/// Parent class of all models
/// Should also implement [fromJson()]
abstract class Model<T> {
  Map<String, dynamic> toJson();
}