part of 'connectivity_cubit.dart';

@immutable
sealed class ConnectivityState extends Equatable {
  const ConnectivityState({required this.connectivityResult});
  factory ConnectivityState.initial() => const ConnectivityDisconnected(
        connectivityResult: [ConnectivityResult.none],
      );

  final List<ConnectivityResult> connectivityResult;

  @override
  List<Object?> get props => [connectivityResult];
}

class ConnectivityConnected extends ConnectivityState {
  const ConnectivityConnected({required super.connectivityResult});
}

class ConnectivityDisconnected extends ConnectivityState {
  const ConnectivityDisconnected({required super.connectivityResult});
}
