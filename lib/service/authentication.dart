import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_api/amplify_api.dart';

import '../amplifyconfiguration.dart';
import '../models/ModelProvider.dart';

class AuthenticationService{

  Future init() async{
    try {
      final auth = AmplifyAuthCognito();
      final storage = AmplifyStorageS3();
      final api = AmplifyAPI(modelProvider: ModelProvider.instance);
      // final dataStore = AmplifyDataStore(modelProvider: ModelProvider.instance);

      await Amplify.addPlugins([auth,storage,api]);

      // call Amplify.configure to use the initialized categories in your app
      await Amplify.configure(amplifyconfig);
    } on Exception catch (e) {
      safePrint('An error occurred configuring Amplify: $e');
    }
  }

  Future register(String email, String username,String password) async{
    try {
      final userAttributes = <CognitoUserAttributeKey, String>{
        CognitoUserAttributeKey.email: email,
        // CognitoUserAttributeKey.phoneNumber: '+15559101234',
        // additional attributes as needed
      };

      print("ok til here 1");

      final result = await Amplify.Auth.signUp(
        username: username,
        password: password,
        options: CognitoSignUpOptions(userAttributes: userAttributes),
      );

      return result.isSignUpComplete;
      
    } on AuthException catch (e) {
      safePrint(e);
    }
  }

  Future Login(String username, String password) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: username,
        password: password,
      );

      return result.isSignedIn;

    } on AuthException catch (e) {
      safePrint(e.message);
    }
  }

  Future getUser(String username) async{
    try {

      final queryPredicate = User.USERNAME.eq(username);

      final request = ModelQueries.list<User>(User.classType, where:queryPredicate);
      final response = await Amplify.API.query(request: request).response;
      final user = response.data;
      if (user== null) {
        print('errors: ${response.errors}');
        return null;
      }
      print(user);
      print("from getuser in authentication: ${user.items[0]}");
      
      return user.items.first;

    } on ApiException catch (e) {
      print('Query failed: $e');
      return null;
    }
  }

  Future OTPVerify(String username,String OTP,String email) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: username,
        confirmationCode: OTP
      );

      if(result.isSignUpComplete){
        try {
          final user = User(username: username, dp: "dp/$username.jpg", email: email,contacts: <String>[]);
          final request = ModelMutations.create(user);
          final response = await Amplify.API.mutate(request: request).response;

          final createdUser = response.data;

          if (createdUser == null) {
            safePrint('errors: ${response.errors}');
            return false;
          }

          safePrint('Mutation result: ${createdUser.username}');
          return result.isSignUpComplete;
        } on ApiException catch (e) {
          safePrint('Mutation failed: $e');
          return false;
        }
      }

      return false;

    } on AuthException catch (e) {
      safePrint(e.message);
    }
  }

  Future<bool> isUserSignedIn() async {
    final result = await Amplify.Auth.fetchAuthSession();
    return result.isSignedIn;
  }

  Future<AuthUser> getCurrentUser() async {
    final user = await Amplify.Auth.getCurrentUser();
    return user;
  }

  Future signOutCurrentUser() async {
    try {
      await Amplify.Auth.signOut();
      return true;
    } on AuthException catch (e) {
      print(e.message);
      return false;
    }
  }
}