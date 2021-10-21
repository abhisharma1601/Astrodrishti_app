import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'astrocubit_state.dart';

class AstrocubitCubit extends Cubit<AstrocubitState> {
  AstrocubitCubit()
      : super(AstrocubitState(astrologer_Name: "Select Astrologer"));

  // ignore: non_constant_identifier_names
  void update_Name(name) {
    emit(AstrocubitState(astrologer_Name: name));
  }
}
