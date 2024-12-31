import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easeyydeal/src/provider/ThemeProvider.dart';
import 'package:easeyydeal/src/repo/services/FirestoreService.dart';
import 'package:easeyydeal/src/repo/services/ThemeService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ThemeService _themeService = ThemeService();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _themeService.getThemeStream().listen((theme) {
      print("dsbjfgkjdfhg  ${theme}");
      Provider.of<ThemeProvider>(context, listen: false).updateTheme(theme);
    });
  }

  final List<String> imageList = [
    'assets/images/img1.jpeg',
    'assets/images/img2.jpeg',
    'assets/images/img3.jpeg',
    'assets/images/img1.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Furniture Utsav')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _firestoreService.fetchUIConfig(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No Data Found'));
          }

          final uiConfig = snapshot.data!;
          return ListView(
            children: [
              _buildHeader(uiConfig['header']),
              ..._buildSections(uiConfig['sections']),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic> header) {
    return AppBar(
      title: Text(header['title']),
      backgroundColor:
          Color(int.parse(header['background_color'].replaceAll('#', '0xff'))),
    );
  }

  List<Widget> _buildSections(List<dynamic> sections) {
    return sections.map((section) {
      if (section['type'] == 'carousel') {
        return _buildCarousel(section);
      } else if (section['type'] == 'category_grid') {
        return _buildCategoryGrid(section);
      } else if (section['type'] == 'offers') {
        return _buildOffers(section);
      } else if (section['type'] == 'deals') {
        return _buildDeals(section);
      }

      return SizedBox.shrink();
    }).toList();
  }

  Widget _buildCarousel(Map<String, dynamic> carousel) {
    return SizedBox(
      height: carousel['height'].toDouble(),
      child: CarouselSlider(
        items: List.generate(
          carousel['images'].length, // Use the count fetched from the backend
          (index) => ClipRRect(
            borderRadius: BorderRadius.circular(carousel['images'][index]
                    ['border_radius']
                .toDouble()), // Rounded corners
            child: Image.asset(
              imageList[index], // Use static images
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
        options: CarouselOptions(
          height: carousel['height'].toDouble(), // Set height of carousel
          autoPlay: carousel['autoplay'],
          enlargeCenterPage: true,
          aspectRatio: 16 / 9,
          viewportFraction: 0.8,
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(Map<String, dynamic> categoryGrid) {
    return Padding(
      padding: EdgeInsets.all(categoryGrid['padding'].toDouble()),
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),

        crossAxisCount: categoryGrid['crossAxisCount'],
        crossAxisSpacing: 10.0,

        children: List.generate(
          categoryGrid['categories'].length,
          (index) {
            final category = categoryGrid['categories'][index];
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('img.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                child: Column(
                  children: [
                    Image.asset(imageList[index], // Use static images
                        fit: BoxFit.cover,
                        width: category['width'].toDouble(),
                        height: category['height'].toDouble()),
                    Text(category['name'],
                        style: TextStyle(
                            color: Color(int.parse(category['text_color']
                                .replaceAll('#', '0xff'))))),
                  ],
                ),
              ),
            );
          },
        ),
        mainAxisSpacing: 10.0,

        // ch: (context, index) {
        //   final category = categoryGrid['categories'][index];
        //   return

        //   // Column(
        //   //   children: [
        //   //     Image.asset(imageList[index], // Use static images
        //   //         fit: BoxFit.cover,
        //   //         width: category['width'].toDouble(),
        //   //         height: category['height'].toDouble()),
        //   //     Text(category['name'],
        //   //         style: TextStyle(
        //   //             color: Color(int.parse(
        //   //                 category['text_color'].replaceAll('#', '0xff'))))),
        //   //   ],
        //   // );
        // },
      ),
    );
  }

  Widget _buildOffers(Map<String, dynamic> offers) {
    return Container(
      color:
          Color(int.parse(offers['background_color'].replaceAll('#', '0xff'))),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: offers['offers'].map<Widget>((offer) {
          return Text(
            offer,
            style: TextStyle(
                color: Color(
                    int.parse(offers['text_color'].replaceAll('#', '0xff'))),
                fontSize: offers['font_size'].toDouble()),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDeals(Map<String, dynamic> deals) {
    return Container(
      height: deals['height'].toDouble(),
      child: Padding(
        padding: EdgeInsets.all(deals['padding'].toDouble()),
        child: Column(
          children: [
            Row(
              children: [
                deals['icon'] ? Icon(Icons.ac_unit_rounded) : SizedBox(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deals['title'],
                      style: TextStyle(fontSize: deals['fontSize'].toDouble()),
                    ),
                    Text(
                      deals['buy'],
                      style:
                          TextStyle(fontSize: deals['fontSize'].toDouble() / 2),
                    )
                  ],
                ),
                Spacer(),
                Text('View all'),
                Icon(
                  Icons.arrow_forward,
                  size: 10,
                )
              ],
            ),
            SizedBox(
              height: 6
              0,
            ),
            Container(
              height: deals['height'].toDouble() / 1.7,
              child: ListView.builder(
                itemCount: deals['deals'].length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final deal = deals['deals'][index];
                  return Container(
                    width: deals['width'].toDouble(),
                    // height: deals['height'].toDouble() / 0.9,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          // Background Image
                          Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset(
                                  imageList[index],
                                  height: 60,
                                  width: double.infinity,
                                ),
                              ),
                              SizedBox(height: 30),
                              Padding(
                                padding: EdgeInsets.only(left: 15, right: 15),
                                child: Container(
                                  child: Text("Flex 3 Seater Magic Bekjrr",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black)),
                                ),
                              )
                            ],
                          ),

                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(int.parse(deal['background_color']
                                    .replaceAll('#', '0xff'))),
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                      deal["bottomLeft"].toDouble()),
                                  bottomRight: Radius.circular(
                                      deal["bottomRight"].toDouble()),
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "-" +
                                                deal["discount"].toString() +
                                                "%",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0, // Big size
                                            ),
                                          ),
                                          TextSpan(
                                            text: " off ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 10.0, // Small size
                                            ),
                                          ),
                                          TextSpan(
                                            text: deal["price"].toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 11.0, // Small size
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Future<void> uploadUIConfig() async {
  //   final uiConfig = {
  //     "header": {
  //       "type": "AppBar",
  //       "title": "Furniture Utsav",
  //       "show_cart_icon": true,
  //       "background_color": "#ffffff",
  //       "height": 56
  //     },
  //     "sections": [
  //       {
  //         "type": "carousel",
  //         "height": 200,
  //         "images": [
  //           {"url": "url1.jpg", "border_radius": 10},
  //           {"url": "url2.jpg", "border_radius": 10}
  //         ]
  //       },
  //       {
  //         "type": "category_grid",
  //         "categories": [
  //           {
  //             "name": "Living Room",
  //             "icon": "living_room_icon.png",
  //             "width": 70,
  //             "height": 70,
  //             "text_color": "#333333"
  //           },
  //           {
  //             "name": "Bedroom",
  //             "icon": "bedroom_icon.png",
  //             "width": 70,
  //             "height": 70,
  //             "text_color": "#333333"
  //           }
  //         ]
  //       },
  //       {
  //         "type": "offers",
  //         "background_color": "#f9f9f9",
  //         "text_color": "#ff5722",
  //         "font_size": 16,
  //         "offers": ["Extra ₹100 off on SBI", "Flat 15% off on select items"]
  //       },
  //       {
  //         "type": "deals",
  //         "deals": [
  //           {
  //             "name": "Flex 3 Seater Magic",
  //             "price": 10499,
  //             "discount": 72,
  //             "image_url": "deal1.jpg",
  //             "width": 150,
  //             "height": 100,
  //             "background_color": "#ffffff"
  //           },
  //           {
  //             "name": "Flex Fabric 3 Seater",
  //             "price": 9499,
  //             "discount": 74,
  //             "image_url": "deal2.jpg",
  //             "width": 150,
  //             "height": 100,
  //             "background_color": "#ffffff"
  //           }
  //         ]
  //       }
  //     ]
  //   };

  //   await FirebaseFirestore.instance
  //       .collection('ui_config')
  //       .doc('config_1') // Custom document ID
  //       .set(uiConfig);

  //   print("UI config uploaded successfully!");
  // }
}
