// import 'package:flutter/material.dart';

// class SurveyPageMenuBar extends StatefulWidget {
//   @override
//   _SurveyPageMenuBarState createState() => _SurveyPageMenuBarState();
// }

// class _SurveyPageMenuBarState extends State<SurveyPageMenuBar> {
//   bool isMenuCollapsed = true;

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         bool isMobile = constraints.maxWidth < 800;
//         double menuBarHeight = isMobile ? 90 : 70;
//         double fontSize = isMobile ? 32 : 24;
//         double iconSize = isMobile ? 48 : 32;
//         double linkSpacing = isMobile ? 20.0 : 24.0;

//         return Column(
//           children: [
//             Container(
//               color: Color(0xFFF5FBF4),
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               height: menuBarHeight,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.home, size: iconSize),
//                     onPressed: () {
//                       Navigator.pushNamed(context, '/');
//                     },
//                   ),
//                   if (!isMobile)
//                     // Menu links for larger screens
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         _buildMenuItem(context, 'Survey', '/survey', fontSize, linkSpacing),
//                         _buildMenuItem(context, 'Band Recommendations', '/band-recommendations', fontSize, linkSpacing),
//                         _buildMenuItem(context, 'Login', '/login', fontSize, linkSpacing),
//                       ],
//                     )
//                   else
//                     // Hamburger menu for smaller screens
//                     IconButton(
//                       icon: Icon(isMenuCollapsed ? Icons.menu : Icons.close, size: iconSize),
//                       onPressed: () {
//                         setState(() {
//                           isMenuCollapsed = !isMenuCollapsed;
//                         });
//                       },
//                     ),
//                 ],
//               ),
//             ),
//             // Show collapsed menu for mobile screens, covering the full screen
//             if (isMobile && !isMenuCollapsed)
//               _buildHamburgerMenu(context, fontSize),
//           ],
//         );
//       },
//     );
//   }

//   // Build a regular menu item 
//   Widget _buildMenuItem(BuildContext context, String title, String route, double fontSize, double linkSpacing) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: linkSpacing),
//       child: InkWell(
//         onTap: () {
//           Navigator.pushNamed(context, route);
//         },
//         child: Text(
//           title,
//           style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
//         ),
//       ),
//     );
//   }

//   // Build a hamburger menu
//   Widget _buildHamburgerMenu(BuildContext context, double fontSize) {
//     return SingleChildScrollView(
//       child: Container(
//         color: Color(0xFFF5FBF4),
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             SizedBox(height: 20),
//             _buildHamburgerMenuButton(context, 'Survey', '/survey', fontSize),
//             _buildHamburgerMenuButton(context, 'Band Recommendations', '/band-recommendations', fontSize),
//             _buildHamburgerMenuButton(context, 'Login', '/login', fontSize),
//           ],
//         ),
//       ),
//     );
//   }

//   // Build a hamburger menu button
//   Widget _buildHamburgerMenuButton(BuildContext context, String title, String route, double fontSize) {
//     return SizedBox(
//       height: 60,
//       child: TextButton(
//         onPressed: () {
//           Navigator.pushNamed(context, route);
//         },
//         style: TextButton.styleFrom(
//           padding: EdgeInsets.symmetric(vertical: 16.0), 
//           backgroundColor: Colors.transparent, 
//           foregroundColor: Color(0xFFEC6246), 
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
//         ),
//         child: Align(
//           alignment: Alignment.centerRight,
//           child: Text(
//             title,
//             style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500, color: Colors.black),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class SurveyPageMenuBar extends StatefulWidget {
  @override
  _SurveyPageMenuBarState createState() => _SurveyPageMenuBarState();
}

class _SurveyPageMenuBarState extends State<SurveyPageMenuBar> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;
        double menuBarHeight = isMobile ? 90 : 70;
        double iconSize = isMobile ? 48 : 32;

        return Column(
          children: [
            Container(
              color: Color(0xFFF5FBF4),
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: menuBarHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, size: iconSize),
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
