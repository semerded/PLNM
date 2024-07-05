import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:path_provider/path_provider.dart';

_write(String text) async {
  final file = await localPath;
  await file.writeAsString(text);
}

Future<File> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  return File('$path/my_file.txt');
}

Future<void> _read() async {
  try {
    final file = await localPath;
    print(await file.readAsString());

  } catch (e) {
    print("Couldn't read file");
  }

}

class GoogleDriveIntegration extends StatefulWidget {
  @override
  _GoogleDriveIntegrationState createState() => _GoogleDriveIntegrationState();
}

class _GoogleDriveIntegrationState extends State<GoogleDriveIntegration> {
  GoogleSignInAccount? _currentUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      drive.DriveApi.driveFileScope,
    ],
  );

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
    // _write("hello");
    // _read();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.disconnect();
  }

  Future<void> _uploadFile() async {
    if (_currentUser == null) {
      return;
    }
    
    final authHeaders = await _currentUser!.authHeaders;
    final authenticateClient = GoogleHttpClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    // Replace with the file you want to upload
    var file = await localPath;
    var stream = file.openRead();
    var media = drive.Media(stream, file.lengthSync());

    var driveFile = drive.File();
    driveFile.name = "uploaded_file_name";

    try {
      var response = await driveApi.files.create(
        driveFile,
        uploadMedia: media,
      );
      print('File uploaded: ${response.name}');
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Drive Integration'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _currentUser != null
                ? Column(
                    children: <Widget>[
                      ListTile(
                        leading: GoogleUserCircleAvatar(
                          identity: _currentUser!,
                        ),
                        title: Text(_currentUser!.displayName ?? ''),
                        subtitle: Text(_currentUser!.email),
                      ),
                      ElevatedButton(
                        onPressed: _uploadFile,
                        child: Text('Upload File to Google Drive'),
                      ),
                      ElevatedButton(
                        onPressed: _handleSignOut,
                        child: Text('SIGN OUT'),
                      ),
                    ],
                  )
                : ElevatedButton(
                    onPressed: _handleSignIn,
                    child: Text('SIGN IN'),
                  ),
          ],
        ),
      ),
    );
  }
}

class GoogleHttpClient extends IOClient {
  final Map<String, String> _headers;

  GoogleHttpClient(this._headers) : super();

  @override
  Future<IOStreamedResponse> send(BaseRequest request) {
    return super.send(request..headers.addAll(_headers));
  }

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) {
    return super.head(url, headers: headers ?? {}..addAll(_headers));
  }
}

void main() {
  runApp(MaterialApp(
    home: GoogleDriveIntegration(),
  ));
}
