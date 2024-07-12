import 'package:alrayada/auth/data/user_api.dart';
import 'package:alrayada/auth/logic/user_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_user_api.dart';

void main() {
  group(UserCubit, () {
    late UserCubit userBloc;
    late UserApi userApi;

    setUp(
      () {
        userApi = MockUserApi();
        userBloc = UserCubit(userApi: userApi);
      },
    );

    test(
      'Inital state is AuthLoggedIn',
      () => expect(
        userBloc.state,
        UserLoggedIn(userCredential: mockUserCredential),
      ),
    );
  });
}
