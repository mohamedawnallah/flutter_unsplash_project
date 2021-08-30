import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String statusCode;
  final String message;
  const Failure({this.statusCode='', this.message=''});
  @override
  // TODO: implement props
  List<Object?> get props => [statusCode,message];
  @override
  // TODO: implement stringify
  bool? get stringify => true;
}
