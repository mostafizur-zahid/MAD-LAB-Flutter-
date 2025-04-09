import 'package:flutter/material.dart';

void main() {
  runApp(const FoodDeliveryApp());
}

class FoodDeliveryApp extends StatelessWidget {
  const FoodDeliveryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Delivery App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
          titleMedium: TextStyle(fontSize: 16, color: Colors.black54),
          labelLarge: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class FoodItem {
  final String name;
  final String imageUrl;
  final double price;
  final String description;
  final List<String> ingredients;
  final int preparationTime;
  final double rating;

  const FoodItem({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.ingredients,
    required this.preparationTime,
    required this.rating,
  });
}

final List<FoodItem> foodItems = [
  FoodItem(
    name: "Margherita Pizza",
    imageUrl:
        "https://secretrecipebd.com/wp-content/uploads/2021/07/Pizza-BBQ-Chicken-.jpg",
    price: 12.99,
    description:
        "Classic Margherita pizza with tomato sauce, mozzarella, and fresh basil.",
    ingredients: ["Tomato Sauce", "Mozzarella", "Fresh Basil", "Olive Oil"],
    preparationTime: 20,
    rating: 4.5,
  ),
  FoodItem(
    name: "Chicken Burger",
    imageUrl:
        "https://fantabulosity.com/wp-content/uploads/2021/10/Crispy-Chicken-Burger-500x500.jpg",
    price: 9.99,
    description:
        "Juicy chicken burger with lettuce, tomato, and special sauce.",
    ingredients: ["Chicken Patty", "Bun", "Lettuce", "Tomato", "Special Sauce"],
    preparationTime: 15,
    rating: 4.2,
  ),
  FoodItem(
    name: "Vegetable Pasta",
    imageUrl:
        "https://www.eatwell101.com/wp-content/uploads/2023/03/vegetarian-pasta-recipe.jpg",
    price: 11.50,
    description: "Healthy vegetable pasta with homemade tomato sauce.",
    ingredients: [
      "Pasta",
      "Tomato",
      "Zucchini",
      "Bell Pepper",
      "Olive Oil",
      "Garlic",
    ],
    preparationTime: 25,
    rating: 4.0,
  ),
  FoodItem(
    name: "Caesar Salad",
    imageUrl:
        "https://steamandbake.com/wp-content/uploads/2022/02/Chicken-Caesar-hero-web-1080x675-1.jpg",
    price: 8.99,
    description:
        "Fresh Caesar salad with grilled chicken, croutons, and Caesar dressing.",
    ingredients: [
      "Romaine Lettuce",
      "Grilled Chicken",
      "Croutons",
      "Parmesan",
      "Caesar Dressing",
    ],
    preparationTime: 10,
    rating: 4.3,
  ),
  FoodItem(
    name: "Sushi Roll",
    imageUrl:
        "https://howdaily.com/wp-content/uploads/2017/12/las-vegas-roll-800x534.jpg?x19738",
    price: 14.99,
    description: "Fresh sushi roll with salmon, avocado, and cucumber.",
    ingredients: ["Rice", "Nori", "Salmon", "Avocado", "Cucumber", "Soy Sauce"],
    preparationTime: 30,
    rating: 4.7,
  ),
  FoodItem(
    name: "Chocolate Cake",
    imageUrl:
        "https://butternutbakeryblog.com/wp-content/uploads/2023/04/chocolate-cake.jpg",
    price: 6.99,
    description: "Delicious chocolate cake with chocolate ganache.",
    ingredients: [
      "Flour",
      "Sugar",
      "Cocoa Powder",
      "Eggs",
      "Butter",
      "Chocolate Ganache",
    ],
    preparationTime: 40,
    rating: 4.8,
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Delivery'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to cart page
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'What would you like to eat today?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Categories
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoryChip('All', true),
                _buildCategoryChip('Pizza', false),
                _buildCategoryChip('Burgers', false),
                _buildCategoryChip('Pasta', false),
                _buildCategoryChip('Salads', false),
                _buildCategoryChip('Desserts', false),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Food Items
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: foodItems.length,
              itemBuilder: (context, index) {
                return _buildFoodCard(context, foodItems[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(label),
        backgroundColor:
            isSelected ? Theme.of(context).primaryColor : Colors.grey[200],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildFoodCard(BuildContext context, FoodItem foodItem) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(foodItem: foodItem),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.network(
                foodItem.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                // Using a placeholder for demo purposes
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.restaurant, size: 40),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foodItem.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        foodItem.rating.toString(),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${foodItem.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(Icons.add, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  final FoodItem foodItem;

  const DetailsScreen({Key? key, required this.foodItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(foodItem.name),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // Add to favorites
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food Image
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Image.network(
                foodItem.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.restaurant, size: 80),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        foodItem.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        '\$${foodItem.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Rating and Preparation Time
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        foodItem.rating.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.timer, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${foodItem.preparationTime} min',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    foodItem.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Ingredients
                  const Text(
                    'Ingredients',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        foodItem.ingredients
                            .map(
                              (ingredient) => Chip(
                                label: Text(ingredient),
                                backgroundColor: Colors.grey[200],
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 32),
                  // Quantity Selector
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                // Decrease quantity
                              },
                            ),
                            const Text(
                              '1',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                // Increase quantity
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${foodItem.name} added to cart!'),
                action: SnackBarAction(
                  label: 'VIEW CART',
                  onPressed: () {
                    // Navigate to cart
                  },
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Add to Cart',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
