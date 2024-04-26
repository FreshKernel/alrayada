import 'package:alrayada/data/user/user_api.dart';
import 'package:alrayada/logic/user/user_cubit.dart';
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
