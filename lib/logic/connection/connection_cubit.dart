import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'connection_state.dart';

class ConnectionCubit extends Cubit<ConnState> {
  ConnectionCubit({required this.connectivity}) : super(ConnState.initial()) {
    _connectionSubscription =
        Connectivity().onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult.contains(ConnectivityResult.none)) {
        emit(ConnStateDisconnected(connectivityResult: connectivityResult));
        return;
      }
      emit(ConnStateConnected(connectivityResult: connectivityResult));
    });
  }
  late StreamSubscription<List<ConnectivityResult>> _connectionSubscription;
  final Connectivity connectivity;

  @override
  Future<void> close() {
    _connectionSubscription.cancel();
    return super.close();
  }
}
