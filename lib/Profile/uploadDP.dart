import 'package:amplify_api/model_mutations.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:chatapp/models/User.dart';

Future<void> createTodo() async {
  try {
    final todo = User(username: 'botuser123', dp: '/s3/mydp.jpg', email: 'botid123@gmail.com',);
    final request = ModelMutations.create(todo);
    final response = await Amplify.API.mutate(request: request).response;

    final createdTodo = response.data;
    if (createdTodo == null) {
      safePrint('errors: ${response.errors}');
      return;
    }
    safePrint('Mutation result: ${createdTodo.username}');
  } on ApiException catch (e) {
    safePrint('Mutation failed: $e');
  }
}