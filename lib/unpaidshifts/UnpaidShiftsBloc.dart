import 'package:cloud_firestore/cloud_firestore.dart';

import 'UnpaidShiftsEvent.dart';
import 'UnpaidShiftsState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnpaidShiftsBloc extends Bloc<UnpaidShiftsEvent,UnpaidShiftsState> {
  UnpaidShiftsBloc() : super(LoadingState()){
    on<LoadDataEvent>(_onLoadShifts);
  }
  void _onLoadShifts(LoadDataEvent event, Emitter<UnpaidShiftsState> emit) async{
    CollectionReference carerUnpaidTime = FirebaseFirestore.instance.collection('carers/alejandra/unpaidtime');
    final resut = await carerUnpaidTime.get();
    final test = resut.size;
    emit(LoadedState());
  }

}