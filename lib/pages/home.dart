import 'package:flutter/material.dart';
import 'package:shoppingapp/pages/category_products.dart';
import 'package:shoppingapp/services/shared_pref.dart';
import 'package:shoppingapp/widget/support_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List categories = [
    "images/headphone_icon.png",
    "images/laptop.png",
    "images/watch.png",
    "images/TV.png",
  ];
  List Categoryname = [
    "Headphones",
    "Laptop",
    "Watch",
    "TV",
  ];
  String? name, image;

  getTheSharedPref() async {
    SharedPreferenceHelper sharedPreferenceHelper = SharedPreferenceHelper();
    name = await sharedPreferenceHelper.getUserName();
    image = await sharedPreferenceHelper.getUserImage();
    setState(() {});
  }

  ontheload() async {
    await getTheSharedPref();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      body: name==null?Center(child: CircularProgressIndicator()): Container(
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
                      "Hey, "+name!,
                      style: AppWidget.boldTextFeildStyle(),
                    ),
                    Text(
                      "Good Morning",
                      style: AppWidget.LightTextFeildStyle(),
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(image!,
                      height: 80, width: 80, fit: BoxFit.cover),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              width: MediaQuery.of(context).size.width,
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Products",
                    hintStyle: AppWidget.LightTextFeildStyle(),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.black,
                    )),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
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
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Container(
                  height: 130,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(right: 20.0),
                  decoration: BoxDecoration(
                      color: Color(0xFFFD6F3E),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "All",
                      style: TextStyle(
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
                          name: Categoryname[index],
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
                  // Sử dụng hàm helper để xây dựng thẻ sản phẩm
                  buildProductCard(
                      "images/headphone2.png", "Headphone", "\$100"),
                  buildProductCard("images/watch2.png", "Apple Watch", "\$150"),
                  buildProductCard("images/laptop2.png", "Laptop", "\$300"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm helper để xây dựng thẻ sản phẩm
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
                    color: Color(0xfffd6f3e),
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
