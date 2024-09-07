import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:res_menu/menu_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glass Restaurant Menu',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.orange,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const MenuPage(),
    );
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final List<String> categories = ['Starters', 'Mains', 'Desserts', 'Drinks'];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // AppBar height
        child: AppBar(
          backgroundColor: Colors.transparent, // Make the AppBar transparent
          elevation: 0, // Remove AppBar shadow
          title: Text(
            'k a l a p a n i',
            style: GoogleFonts.aBeeZee(
              textStyle: const TextStyle(
                fontSize: 24,
                fontStyle: FontStyle.italic, // Apply italic style
                color: Colors.white,
              ),
            ),
          ),
          centerTitle: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.pink.shade400,
                  Colors.orange.shade400,
                ], // Define the gradient colors
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade400, Colors.pink.shade400],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
          // Menu items grid
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(child: _buildMenuItems(isMobile)),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.white.withOpacity(0.8),
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: categories
            .map((category) => BottomNavigationBarItem(
                  icon: const Icon(Icons.fastfood),
                  label: category,
                ))
            .toList(),
      ),
    );
  }

  // Building staggered grid layout for menu items
  Widget _buildMenuItems(bool isMobile) {
    final filteredItems = menuItems
        .where((item) => item['category'] == categories[_selectedIndex])
        .toList();

    return MasonryGridView.count(
      crossAxisCount: isMobile ? 2 : 4,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return _buildMenuItemCard(item);
      },
    );
  }

  // Menu Item Card with glass effect and animations
  Widget _buildMenuItemCard(Map<String, String> item) {
    return InkWell(
      onTap: () {},
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 250,
        borderRadius: 15,
        blur: 20,
        alignment: Alignment.bottomCenter,
        border: 2,
        linearGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.4),
            Colors.white.withOpacity(0.1)
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  item['image']!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    item['name']!,
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    '\$${item['price']}',
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
