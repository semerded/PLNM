import "package:keeper_of_projects/data.dart";

Future<void> handleSignIn() async {
    try {
      await googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> handleSignOut() async {
    await googleSignIn.disconnect();
  }