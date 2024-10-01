import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoppingapp/pages/category_products.dart';
import 'package:shoppingapp/pages/product_detail.dart';
import 'package:shoppingapp/services/database.dart';
import 'package:shoppingapp/services/shared_pref.dart';
import 'package:shoppingapp/widget/support_widget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool search = false;
  List<String> categories = [
    "images/headphone_icon.png",
    "images/laptop.png",
    "images/watch.png",
    "images/TV.png",
  ];
  List<String> categoryNames = [
    "Headphones",
    "Laptop",
    "Watch",
    "TV",
  ];

  List<dynamic> queryResultSet = [];
  List<dynamic> tempSearchStore = [];
  TextEditingController searchController = TextEditingController();
  late Stream<QuerySnapshot> allProductsStream;

  void initiateSearch(String value) {
    if (value.isEmpty) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
        search = false;
      });
      return;
    }

    setState(() {
      search = true;
    });

    DatabaseMethods().search(value).then((QuerySnapshot docs) {
      if (docs.docs.isEmpty) {
        setState(() {
          tempSearchStore = [];
        });
        return;
      }

      queryResultSet = docs.docs.map((doc) => doc.data()).toList();

      tempSearchStore = queryResultSet.where((element) {
        return element['UpdatedName']
            .toLowerCase()
            .startsWith(value.toLowerCase());
      }).toList();

      setState(() {});
    });
  }

  String? name, image;

  Future<void> getTheSharedPref() async {
    SharedPreferenceHelper sharedPreferenceHelper = SharedPreferenceHelper();
    name = await sharedPreferenceHelper.getUserName();
    image = await sharedPreferenceHelper.getUserImage();
    setState(() {});
  }

  Future<void> onTheProductLoad() async {
    allProductsStream = DatabaseMethods().getAllProducts(); // Initialize stream
    await getTheSharedPref();
  }

  @override
  void initState() {
    super.initState();
    getTheSharedPref();
    onTheProductLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      body: name == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
              margin: const EdgeInsets.only(top: 45.0, right: 20.0, left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildUserInfo(),
                  const SizedBox(height: 30.0),
                  buildSearchField(),
                  const SizedBox(height: 20.0),
                  search ? buildSearchResults() : buildCategoriesAndProducts(),
                ],
              ),
            ),
    );
  }

  Widget buildUserInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hey, $name!",
              style: AppWidget.boldTextFeildStyle(),
            ),
            const Text(
              "Good Morning",
            ),
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: image != null
              ? Image.network(image!, height: 80, width: 80, fit: BoxFit.cover)
              : const SizedBox(
                  height: 80,
                  width: 80,
                  child: CircularProgressIndicator(),
                ),
        ),
      ],
    );
  }

  Widget buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      width: MediaQuery.of(context).size.width,
      child: TextField(
        controller: searchController,
        onChanged: (value) => initiateSearch(value),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Search Products",
          hintStyle: AppWidget.LightTextFeildStyle(),
          prefixIcon: search
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      search = false;
                      tempSearchStore = [];
                      queryResultSet = [];
                      searchController.text = "";
                    });
                  },
                  child: const Icon(Icons.close),
                )
              : const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
        ),
      ),
    );
  }

  Widget buildSearchResults() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      primary: false,
      shrinkWrap: true,
      children: tempSearchStore.map((element) {
        return buildProductCard(
          element['Image'],
          element['UpdatedName'],
          "\$${element['Price']}",
          element,
        );
      }).toList(),
    );
  }

  Widget buildCategoriesAndProducts() {
    return Column(
      children: [
        buildCategoryHeader(),
        const SizedBox(height: 20.0),
        buildCategoryList(),
        const SizedBox(height: 30.0),
        buildProductHeader(),
        const SizedBox(height: 30.0),
        buildProductStream(),
      ],
    );
  }

  Widget buildCategoryHeader() {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Categories",
            style: AppWidget.semiBoldTextFeildStyle(),
          ),
          const Text(
            "See all",
            style: TextStyle(
              color: Color(0xFFfd6f3e),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryList() {
    return Row(
      children: [
        Container(
          height: 130,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(right: 20.0),
          decoration: BoxDecoration(
            color: const Color(0xFFFD6F3E),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: const Text(
              "All",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 20.0),
            height: 130,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: categories.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return CategoryTile(
                  image: categories[index],
                  name: categoryNames[index],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildProductHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "All Products",
          style: AppWidget.semiBoldTextFeildStyle(),
        ),
        const Text(
          "See all",
          style: TextStyle(
            color: Color(0xFFfd6f3e),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildProductStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: allProductsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Container(
            height: 240,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: snapshot.data!.docs.map((doc) {
                var data = doc.data() as Map<String, dynamic>;
                return buildProductCard(
                  data["Image"],
                  data["Name"],
                  "\$${data["Price"]}",
                  data,
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }

  // Helper method to build a product card
  Widget buildProductCard(
      String imageUrl, String title, String price, dynamic data) {
    return Container(
      margin: const EdgeInsets.only(right: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Image.network(imageUrl, height: 140, width: 150, fit: BoxFit.cover),
          Text(title, style: AppWidget.semiBoldTextFeildStyle()),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Aligns items in the row
            children: [
              Text(
                price,
                style: const TextStyle(
                  color: Color.fromARGB(255, 168, 39, 39),
                  fontSize: 20.0, // Change this to your desired font size
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetail(
                        name: data["Name"],
                        price: data["Price"],
                        detail: data["Detail"],
                        image: data["Image"],
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFD6F3E),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(8.0), // Add some padding
                  child: Icon(
                    Icons.add,
                    size: 24.0, // Adjust icon size
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String image, name;

  const CategoryTile({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryProducts(category: name)));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              image,
              height: 55,
              width: 55,
              fit: BoxFit.cover,
            ),
            const Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}
