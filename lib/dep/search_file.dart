import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart';
import 'package:http/io_client.dart';

class GoogleDriveSearch extends StatefulWidget {
  @override
  _GoogleDriveSearchState createState() => _GoogleDriveSearchState();
}

class _GoogleDriveSearchState extends State<GoogleDriveSearch> {
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
        q: "name contains '$query'",
        spaces: 'drive',
        $fields: "files(id, name)",
      );
      return result.files;
    } catch (e) {
      print('Error searching files: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Drive Search'),
      ),
      body: Center(
        child: _currentUser != null
            ? Column(                mainAxisAlignment: MainAxisAlignment.center,
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
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Search Results'),
                            content: Container(
                              width: double.maxFinite,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: files?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(files![index].name ?? ''),
                                    subtitle: Text(files[index].id ?? ''),
                                  );
                                },
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter file name',
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
    home: GoogleDriveSearch(),
  ));
}
