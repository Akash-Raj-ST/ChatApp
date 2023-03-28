import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import '../amplifyconfiguration.dart';

class AuthenticationService{

  Future init() async{
    try {
      final auth = AmplifyAuthCognito();
      await Amplify.addPlugin(auth);

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
      final result = await Amplify.Auth.signUp(
        username: username,
        password: password,
        options: CognitoSignUpOptions(userAttributes: userAttributes),
      );
      
      return result.isSignUpComplete;
      
    } on AuthException catch (e) {
      safePrint(e.message);
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

  Future OTPVerify(String username,String OTP) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: username,
        confirmationCode: OTP
      );

      return result.isSignUpComplete;

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