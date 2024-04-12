import 'dart:async' show StreamSubscription;

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit({required this.connectivity})
      : super(ConnectivityState.initial()) {
    _connectionSubscription =
        Connectivity().onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult.contains(ConnectivityResult.none)) {
        emit(ConnectivityDisconnected(connectivityResult: connectivityResult));
        return;
      }
      emit(ConnectivityConnected(connectivityResult: connectivityResult));
    });
  }

  @override
  Future<void> close() {
    _connectionSubscription.cancel();
    return super.close();
  }

  late StreamSubscription<List<ConnectivityResult>> _connectionSubscription;
  final Connectivity connectivity;
}
