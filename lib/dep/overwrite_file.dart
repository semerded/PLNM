import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart';
import 'package:http/io_client.dart';

class GoogleDriveOverwrite extends StatefulWidget {
  @override
  _GoogleDriveOverwriteState createState() => _GoogleDriveOverwriteState();
}

class _GoogleDriveOverwriteState extends State<GoogleDriveOverwrite> {
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

  Future<List<drive.File>?> _searchFiles(String query) async {
    if (_currentUser == null) {
      return null;
    }
    
    final authHeaders = await _currentUser!.authHeaders;
    final authenticateClient = GoogleHttpClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    try {
      drive.FileList result = await driveApi.files.list(
        q: "name = '$query'",
        spaces: 'drive',
        $fields: "files(id, name)",
      );
      return result.files;
    } catch (e) {
      print('Error searching files: $e');
      return null;
    }
  }

  Future<void> _overwriteFile(String fileId, File newFile) async {
    if (_currentUser == null) {
      return;
    }
    
    final authHeaders = await _currentUser!.authHeaders;
    final authenticateClient = GoogleHttpClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    var stream = newFile.openRead();
    var media = drive.Media(stream, newFile.lengthSync());

    var driveFile = drive.File();

    try {
      var response = await driveApi.files.update(
        driveFile,
        fileId,
        uploadMedia: media,
      );
      print('File overwritten: ${response.name}');
    } catch (e) {
      print('Error overwriting file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Drive Overwrite'),
      ),
      body: Center(
        child: _currentUser != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    leading: GoogleUserCircleAvatar(
                      identity: _currentUser!,
                    ),
                    title: Text(_currentUser!.displayName ?? ''),
                    subtitle: Text(_currentUser!.email),
                  ),
                  ElevatedButton(
                    onPressed: _handleSignOut,
                    child: Text('SIGN OUT'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onSubmitted: (value) async {
                        List<drive.File>? files = await _searchFiles(value);
                        if (files != null && files.isNotEmpty) {
                          // Assuming the new file is 'path_to_your_new_file'
                          File newFile = File('path_to_your_new_file');
                          await _overwriteFile(files.first.id!, newFile);
                        } else {
                          print('File not found');
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter file name to overwrite',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              )
            : ElevatedButton(
                onPressed: _handleSignIn,
                child: Text('SIGN IN'),
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
    home: GoogleDriveOverwrite(),
  ));
}
