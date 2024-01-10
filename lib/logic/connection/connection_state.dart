part of 'connection_cubit.dart';

@immutable
sealed class ConnState extends Equatable {
  const ConnState({required this.connectivityResult});
  factory ConnState.initial() =>
      const ConnStateDisconnected(connectivityResult: ConnectivityResult.none);

  final ConnectivityResult connectivityResult;
}

class ConnStateConnected extends ConnState {
  const ConnStateConnected({required super.connectivityResult});

  @override
  List<Object?> get props => [connectivityResult];
}

class ConnStateDisconnected extends ConnState {
  const ConnStateDisconnected({required super.connectivityResult});

  @override
  List<Object?> get props => [connectivityResult];
}
