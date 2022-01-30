import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'astrocubit_state.dart';

class AstrocubitCubit extends Cubit<AstrocubitState> {
  AstrocubitCubit()
      : super(AstrocubitState(
            astrologer_Name: "Select Astrologer", progress: false));

  // ignore: non_constant_identifier_names
  void update_Name(name) {
    emit(AstrocubitState(
        astrologer_Name: name, progress: AstrocubitCubit().state.progress));
  }

  void set_progress(val) {
    print(val);
    emit(AstrocubitState(
        astrologer_Name: AstrocubitCubit().state.astrologer_Name,
        progress: val));
  }
}
