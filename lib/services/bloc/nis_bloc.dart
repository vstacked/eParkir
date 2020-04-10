import 'package:bloc/bloc.dart';

class NisBloc extends Bloc<String, String> {
  @override
  String get initialState => "";

  @override
  Stream<String> mapEventToState(String event) async* {
    yield event.toString();
  }
}
