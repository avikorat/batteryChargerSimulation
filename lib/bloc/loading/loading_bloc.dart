import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc/loading/loading_event.dart';

class LoadingBloc extends Bloc<LoadingEvent, bool>
    implements StateStreamable<bool> {
  LoadingBloc() : super(false) {
    on<Loading>((event, emit) {
      emit(event.incomingData);
    });
  }
}
