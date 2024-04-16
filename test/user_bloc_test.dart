import 'package:alrayada/data/user/user_repository.dart';
import 'package:alrayada/logic/user/user_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import 'user_repository_mock.dart';

void main() {
  group(UserCubit, () {
    late UserCubit authCubit;
    late UserRepository authRepository;

    setUp(
      () {
        authRepository = UserRepositoryMock();
        authCubit = UserCubit(userRepository: authRepository);
      },
    );

    test(
      'Inital state is AuthLoggedIn',
      () => expect(
        authCubit.state,
        UserLoggedIn(userCredential: mockUserCredential),
      ),
    );
  });
}
