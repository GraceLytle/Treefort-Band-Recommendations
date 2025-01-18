import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_2/features/auth/auth_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ResponsiveMenuBar extends StatefulWidget {
  const ResponsiveMenuBar({super.key});

  @override
  _ResponsiveMenuBarState createState() => _ResponsiveMenuBarState();
}

class _ResponsiveMenuBarState extends State<ResponsiveMenuBar> {
  bool isMenuCollapsed = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final redirectUrl = dotenv.env['REDIRECT_URL'] ?? '';
    final logoutReturnUrl = dotenv.env['LOGOUT_RETURN_URL'] ?? '';

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile =
            constraints.maxWidth < 918; // Updated breakpoint for hamburger menu
        double menuBarHeight = isMobile ? 90 : 70;
        double fontSize = isMobile ? 32 : 24;
        double iconSize = isMobile ? 48 : 32;
        double linkSpacing = isMobile ? 20.0 : 24.0;

        return Column(
          children: [
            Container(
              color: const Color(0xFFB18CD9).withOpacity(.8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: menuBarHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.home, size: iconSize),
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                  ),
                  if (!isMobile)
                    // Menu links for larger screens
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Center alignment
                      children: [
                        _buildMenuItem(context, 'Set Music Preferences',
                            '/survey', fontSize, linkSpacing),
                        _buildMenuItem(context, 'Lineup', '/lineup', fontSize,
                            linkSpacing),
                        _buildMenuItem(context, 'Band Recommendations',
                            '/band-recommendations', fontSize, linkSpacing),
                        // Conditional Login/Logout Button
                        authProvider.credentials == null
                            ? _buildLoginButton(context, authProvider,
                                redirectUrl, fontSize, linkSpacing)
                            : _buildLogoutButton(context, authProvider,
                                logoutReturnUrl, fontSize, linkSpacing),
                      ],
                    )
                  else
                    // Hamburger menu for smaller screens
                    IconButton(
                      icon: Icon(isMenuCollapsed ? Icons.menu : Icons.close,
                          size: iconSize),
                      onPressed: () {
                        setState(() {
                          isMenuCollapsed = !isMenuCollapsed;
                        });
                      },
                    ),
                ],
              ),
            ),
            // Show collapsed menu for mobile screens, covering the full screen
            if (isMobile && !isMenuCollapsed)
              _buildHamburgerMenu(context, fontSize, authProvider, redirectUrl,
                  logoutReturnUrl),
          ],
        );
      },
    );
  }

  // Build a regular menu item
  Widget _buildMenuItem(BuildContext context, String title, String route,
      double fontSize, double linkSpacing) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: linkSpacing),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Text(
          title,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  // Build a Login button for large screens
  Widget _buildLoginButton(BuildContext context, AuthProvider authProvider,
      String redirectUrl, double fontSize, double linkSpacing) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: linkSpacing),
      child: InkWell(
        onTap: () => authProvider.login(redirectUrl),
        child: Text(
          'Login',
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  // Build a Logout button for large screens
  Widget _buildLogoutButton(BuildContext context, AuthProvider authProvider,
      String logoutReturnUrl, double fontSize, double linkSpacing) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: linkSpacing),
      child: InkWell(
        onTap: () => authProvider.logout(logoutReturnUrl),
        child: Text(
          'Logout',
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  // Build a hamburger menu
  Widget _buildHamburgerMenu(BuildContext context, double fontSize,
      AuthProvider authProvider, String redirectUrl, String logoutReturnUrl) {
    return SingleChildScrollView(
      child: Container(
        color: Color(0xFFB18CD9).withOpacity(.5),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16), // Add padding here
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
          children: [
            const SizedBox(height: 20),
            _buildHamburgerMenuButton(
                context, 'Set Preferences', '/survey', fontSize),
            _buildHamburgerMenuButton(context, 'Lineup', '/lineup', fontSize),
            _buildHamburgerMenuButton(
                context, 'Band Recs', '/band-recommendations', fontSize),
            // Conditional Login/Logout Button in hamburger menu
            authProvider.credentials == null
                ? _buildHamburgerMenuButton(context, 'Login', '', fontSize,
                    onTap: () => authProvider.login(redirectUrl))
                : _buildHamburgerMenuButton(context, 'Logout', '', fontSize,
                    onTap: () => authProvider.logout(logoutReturnUrl)),
          ],
        ),
      ),
    );
  }

  // Build a hamburger menu button with an optional custom onTap function
  Widget _buildHamburgerMenuButton(
      BuildContext context, String title, String route, double fontSize,
      {VoidCallback? onTap}) {
    return SizedBox(
      height: 80,
      child: TextButton(
        onPressed: onTap ?? () => Navigator.pushNamed(context, route),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          backgroundColor: Colors.transparent,
          foregroundColor: const Color(0xFFEC6246),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            title,
            style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
        ),
      ),
    );
  }
}
