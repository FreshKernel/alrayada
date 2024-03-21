import 'package:alrayada/data/user/auth_repository.dart';
import 'package:alrayada/logic/auth/auth_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import 'auth_repository_mock.dart';

void main() {
  group(AuthCubit, () {
    late AuthCubit authCubit;
    late AuthRepository authRepository;

    setUp(
      () {
        authRepository = AuthRepositoryMock();
        authCubit = AuthCubit(authRepository: authRepository);
      },
    );

    test(
      'Inital state is AuthLoggedIn',
      () => expect(
        authCubit.state,
        AuthLoggedIn(userCredential: mockUserCredential),
      ),
    );
  });
}
