import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoppingapp/pages/category_products.dart';
import 'package:shoppingapp/pages/product_detail.dart';
import 'package:shoppingapp/services/database.dart';
import 'package:shoppingapp/services/shared_pref.dart';
import 'package:shoppingapp/widget/support_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

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
  TextEditingController searchcontroller = new TextEditingController();

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

  Future<void> onTheLoad() async {
    await getTheSharedPref();
  }

  @override
  void initState() {
    onTheLoad();
    super.initState();
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
                  Row(
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
                            ? Image.network(image!,
                                height: 80, width: 80, fit: BoxFit.cover)
                            : const SizedBox(
                                height: 80,
                                width: 80,
                                child: CircularProgressIndicator()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30.0),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      controller: searchcontroller,
                      onChanged: (value) => initiateSearch(value.toUpperCase()),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search Products",
                          hintStyle: AppWidget.LightTextFeildStyle(),
                          prefixIcon: search
                              ? GestureDetector(
                                  onTap: () {
                                    search = false;
                                    tempSearchStore = [];
                                    queryResultSet = [];
                                    searchcontroller.text = "";
                                    setState(() {});
                                  },
                                  child: Icon(Icons.close))
                              : Icon(
                                  Icons.search,
                                  color: Colors.black,
                                )),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  search
                      ? ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          primary: false,
                          shrinkWrap: true,
                          children: tempSearchStore.map((element) {
                            return buildResultCard(element);
                          }).toList(),
                        )
                      : Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Row(
                              children: [
                                Container(
                                  height: 130,
                                  padding: const EdgeInsets.all(20),
                                  margin: const EdgeInsets.only(right: 20.0),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFFD6F3E),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      "All",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
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
                            ),
                            const SizedBox(height: 30.0),
                            Row(
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
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            Container(
                              height: 240,
                              child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: [
                                  buildProductCard("images/headphone2.png",
                                      "Headphone", "\$100"),
                                  buildProductCard("images/watch2.png",
                                      "Apple Watch", "\$150"),
                                  buildProductCard(
                                      "images/laptop2.png", "Laptop", "\$300"),
                                ],
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
    );
  }

  // Helper method to build a product card
  Widget buildProductCard(String imagePath, String title, String price) {
    return Container(
      margin: const EdgeInsets.only(right: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Image.asset(imagePath, height: 150, width: 150, fit: BoxFit.cover),
          Text(
            title,
            style: AppWidget.semiBoldTextFeildStyle(),
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              Text(
                price,
                style: const TextStyle(
                    color: Color(0xFFfd6f3e),
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 50.0),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: const Color(0xfffd6f3e),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Method to build the search result card
  Widget buildResultCard(dynamic data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetail(
                      detail: data["Detail"],
                      image: data["Image"],
                      name: data["Name"],
                      price: data["Price"],
                    )));
      },
      child: Container(
        padding: EdgeInsets.only(left: 20.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 100,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(data["Image"],
                  height: 70, width: 70, fit: BoxFit.cover),
            ),
            const SizedBox(width: 20.0),
            Text(data["Name"], style: AppWidget.semiBoldTextFeildStyle()),
          ],
        ),
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
