import "dart:io";

import "package:keeper_of_projects/backend/google_api/desktop_token_storage.dart";
import "package:keeper_of_projects/data.dart";

Future<void> handleSignIn() async {
  try {
    await googleSignIn.signIn();
  } catch (error) {
    print(error);
  }
}

Future<void> handleSignOut() async {
  if (Platform.isAndroid || Platform.isIOS) {
    await googleSignIn.disconnect();
  } else {
    logout();
  }
  currentUser = null;
}
