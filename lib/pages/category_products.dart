import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoppingapp/pages/product_detail.dart';
import 'package:shoppingapp/services/database.dart';
import 'package:shoppingapp/widget/support_widget.dart';

class CategoryProducts extends StatefulWidget {
  final String category;
  CategoryProducts({required this.category});

  @override
  State<CategoryProducts> createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  Stream<QuerySnapshot>? categoryStream;

  @override
  void initState() {
    super.initState();
    getOnTheLoads();
  }

  getOnTheLoads() async {
    categoryStream = await DatabaseMethods().getProducts(widget.category);
    setState(() {});
  }

  Widget allProduct() {
    return StreamBuilder<QuerySnapshot>(
      stream: categoryStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No products found.'));
        }

        return GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10.0,
          ),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data!.docs[index];

            String imagePath = ds["Image"] ?? '';

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  // Load the image with an error fallback
                  imagePath.isNotEmpty
                      ? Image.network(
                          imagePath,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'images/default_image.png',
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          'images/default_image.png',
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    ds["Name"] ?? 'No Name',
                    style: AppWidget.semiBoldTextFeildStyle(),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Text(
                        "\$${ds["Price"] ?? '0.0'}",
                        style: TextStyle(
                          color: Color(0xFFfd6f3e),
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 30.0),
                      GestureDetector(
                        onTap: (){
                           Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetail(name: ds["Name"], price: ds["Price"], detail: ds["Detail"], image: ds["Image"])));
           
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Color(0xfffd6f3e),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f2f2),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
            Expanded(child: allProduct()),
          ],
        ),
      ),
    );
  }
}
