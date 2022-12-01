import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:olive/modules/daycare_module/daycare_theme.dart';

import '../../entities/daycare_entities.dart';
import '../daycare_module/daycare_home_screen.dart';
import 'theme.dart';

class SignInPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SignInPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  UserProfile? userProfile;
  String? userEmail;
  StoredAccessToken? accessToken;
  AnimationController? animationController;
  final ScrollController _scrollController = ScrollController();
  List<Daycare> daycareList = [];
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));
  // bool _isOnlyWebLogin = false;

  final Set<String> _selectedScopes = Set.from(['profile']);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    UserProfile? userProfile;
    StoredAccessToken? accessToken;

    try {
      accessToken = await LineSDK.instance.currentAccessToken;
      if (accessToken != null) {
        userProfile = await LineSDK.instance.getProfile();
      }
    } on PlatformException catch (e) {
      print(e.message);
    }

    if (!mounted) return;

    setState(() {
      userProfile = userProfile;
      accessToken = accessToken;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (userProfile == null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            _configCard(),
            Expanded(
              child: Center(
                  child: ElevatedButton(
                      child: Text('Sign In'),
                      onPressed: _signIn,
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              DaycareAppTheme.buildLightTheme().backgroundColor,
                          foregroundColor: textColor))),
            ),
          ],
        ),
      );
    } else {
      return DaycareHomeScreen();
    }
  }

  Widget _configCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _scopeListUI(),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _scopeListUI() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Scopes: '),
          Wrap(
            children:
                _scopes.map<Widget>((scope) => _buildScopeChip(scope)).toList(),
          ),
        ],
      );

  Widget _buildScopeChip(String scope) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ChipTheme(
          data: ChipTheme.of(context).copyWith(brightness: Brightness.dark),
          child: FilterChip(
            label: Text(scope, style: TextStyle(color: textColor)),
            selectedColor: DaycareAppTheme.buildLightTheme().primaryColor,
            backgroundColor: secondaryBackgroundColor,
            selected: _selectedScopes.contains(scope),
            onSelected: (_) {
              setState(() {
                _selectedScopes.contains(scope)
                    ? _selectedScopes.remove(scope)
                    : _selectedScopes.add(scope);
              });
            },
          ),
        ),
      );

  void _signIn() async {
    try {
      final result =
          await LineSDK.instance.login(scopes: _selectedScopes.toList());
      final _accessToken = await LineSDK.instance.currentAccessToken;

      final _userEmail = result.accessToken.email;

      setState(() {
        userProfile = result.userProfile;
        userEmail = _userEmail;
        accessToken = _accessToken;
      });
    } on PlatformException catch (e) {
      _showDialog(context, e.toString());
    }
  }

  void _signOut() async {
    try {
      await LineSDK.instance.logout();
      setState(() {
        userProfile = null;
        userEmail = null;
        accessToken = null;
      });
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  void _showDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(text),
          actions: <Widget>[
            TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                    foregroundColor: DaycareAppTheme.buildLightTheme()
                        .secondaryHeaderColor)),
          ],
        );
      },
    );
  }
}

const List<String> _scopes = <String>['profile', 'openid', 'email'];