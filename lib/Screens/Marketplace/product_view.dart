import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:trova/class/image_location.dart';
import 'package:trova/class/product_class.dart';
import 'package:trova/widget/bottom_bar.dart';

import '../../widget/AddReviewBottomBar.dart';

class ProductView extends StatefulWidget {
  Map<String, dynamic> itemDetails;
  ProductView({super.key, required this.itemDetails});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  double? _deviceHeight;
  double? _deviceWidth;
  bool canRent = false;
  String resualtText = "Select Date Range";
  int qty = 1;
  double? price;
  int? itemLimit = 1;
  @override
  void initState() {
    super.initState();
    price = double.parse(widget.itemDetails['price'].toString());
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Container(
        child: _mainFrame(),
      )),
    );
  }

  // Prodduct view main frame
  Widget _mainFrame() {
    return Stack(children: [
      Column(
        children: [
          _imageView(),
          _productName(),
          _descriptionContainer(),
        ],
      ),
      _bottomContainer()
    ]);
  }

  Widget _imageView() {
    return SizedBox(
      width: _deviceWidth,
      height: _deviceHeight! * 0.35,
      child: Stack(
        children: [
          SizedBox(
              width: _deviceWidth,
              height: _deviceHeight! * 0.35,
              child: PageView.builder(
                  padEnds: false,
                  itemCount: widget.itemDetails['images'].length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      ImageLocation().imageUrl(widget.itemDetails['images'][index]),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                    );
                  })),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
                margin: EdgeInsets.only(
                    top: _deviceWidth! * 0.005, left: _deviceWidth! * 0.02),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios))),
          )
        ],
      ),
    );
  }

  Widget _productName() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth! * 0.05, vertical: _deviceHeight! * 0.01),
      height: _deviceHeight! * 0.15,
      width: _deviceWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            indent: 20,
            endIndent: 20,
          ),
          Text(
            widget.itemDetails['name'],
            style: TextStyle(
                fontSize: _deviceHeight! * 0.045, fontWeight: FontWeight.bold),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RatingStars(
                value: widget.itemDetails['avgReviewRate'] != null
                    ? double.parse(
                        widget.itemDetails['avgReviewRate'].toString())
                    : 2.5,
                valueLabelVisibility: false,
                starColor: const Color.fromARGB(255, 250, 166, 18),
                starOffColor: const Color.fromARGB(176, 0, 0, 0),
              ),
              SizedBox(width: _deviceWidth! * 0.05),
              Text(
                '${widget.itemDetails['totalReviews'].toString()} reviews',
                style: const TextStyle(color: Color.fromARGB(255, 141, 127, 2)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _descriptionContainer() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _deviceWidth! * 0.05,
      ),
      width: _deviceWidth,
      height: _deviceHeight! * 0.3,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.01),
              child: Text(widget.itemDetails['description']),
            ),

            Container(
              padding: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.005),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Reviews',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_comment),  // Plus icon
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(34),
                            topRight: Radius.circular(34),
                          ),
                        ),
                        builder: (context) {
                          return AddReviewBottomBar(
                            productId: widget.itemDetails['productId'].toString(), // Pass the product ID
                          );
                        },
                      );
                    },
                  ),

                ],
              ),
            ),


            // Reviews Tiles
            _reviewsTiles(),
            _sellerDetails(),
          ],
        ),
      ),
    );
  }

  Widget _bottomContainer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: _deviceWidth,
        height: _deviceHeight! * 0.1,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Center(
          child: SizedBox(
            width: _deviceWidth! * 0.9,
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(34),
                      topRight: Radius.circular(34),
                    ),
                  ),
                  builder: (context) {
                    return BottomBar(
                      itemDetails: widget.itemDetails,
                      onReservationResult:
                          (String resultText, bool canRent, int itemLimit) {
                        print(resultText);
                      },
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF238688),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: _deviceWidth! * 0.2,
                    vertical: _deviceHeight! * 0.02),
              ),
              child: Text(
                'Rent now',
                style: TextStyle(
                    fontSize: _deviceWidth! * 0.05, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _reviewsTiles() {
    return FutureBuilder(
        future: ProductClass()
            .getReviews(int.parse(widget.itemDetails['productId'].toString())),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No reviews available.'));
          }

          var reviews = snapshot.data!;
          return Column(
            children: List.generate(reviews.length, (index) {
              Map<String, dynamic> review = reviews[index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.01),
                padding: EdgeInsets.symmetric(
                    horizontal: _deviceWidth! * 0.03,
                    vertical: _deviceHeight! * 0.01),
                width: _deviceWidth,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFE0EEEE)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          ImageLocation().imageUrl(review['profilepic'].toString())),
                      radius: 25,
                    ),
                    SizedBox(
                      width: _deviceWidth! * 0.03,
                    ),
                    SizedBox(
                      width: _deviceWidth! * 0.65,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review['username'],
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              Text(review['review_content'])
                            ],
                          ),
                          RatingStars(
                            valueLabelVisibility: false,
                            value:
                                double.parse(review['reviewRate'].toString()),
                            starSize: 15,
                            starColor: const Color.fromARGB(255, 250, 166, 18),
                            starOffColor: const Color.fromARGB(176, 0, 0, 0),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
          );
        });
  }

  Widget _sellerDetails() {
    return Center(
      child: Column(
        children: [
          const Text(
            'Sellers Details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.005),
            height: _deviceHeight! * 0.15,
            width: _deviceWidth! * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  spreadRadius: 0,
                  blurRadius: 20, // Increased blur radius
                  offset: const Offset(0, 4),
                )
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          ImageLocation().imageUrl(widget.itemDetails['profile'].toString())),
                      radius: _deviceWidth! * 0.1,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.itemDetails['sellername'],
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "Verify Seller",
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showBottomBar(BuildContext context) async {
    DateTime? startDate;
    DateTime? endDate;

    Future<void> pickDateRange(BuildContext context) async {
      final DateTime now = DateTime.now();
      DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: now,
        lastDate: DateTime(now.year + 2),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.teal,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        startDate = picked.start;
        endDate = picked.end;
      }
    }

    // showModalBottomSheet(
    //   context: context,
    //   shape: const RoundedRectangleBorder(
    //     borderRadius: BorderRadius.only(
    //       topLeft: Radius.circular(34),
    //       topRight: Radius.circular(34),
    //     ),
    //   ),
    //   builder: (BuildContext context) {
    //     return Container(
    //       height: _deviceHeight! * 0.6,
    //       padding: EdgeInsets.symmetric(
    //           horizontal: MediaQuery.of(context).size.width * 0.05),
    //       decoration: const BoxDecoration(
    //         color: Color.fromARGB(255, 224, 238, 238),
    //         borderRadius: BorderRadius.only(
    //           topLeft: Radius.circular(34),
    //           topRight: Radius.circular(34),
    //         ),
    //       ),
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           const Divider(
    //             thickness: 5,
    //             height: 40,
    //             indent: 150,
    //             endIndent: 150,
    //             color: Color.fromARGB(255, 161, 161, 161),
    //           ),
    //           const Text(
    //             "Check Availability",
    //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
    //             textAlign: TextAlign.start,
    //           ),
    //           SizedBox(height: 20),
    // Date selection row
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 // Start Date
    //                 Expanded(
    //                   child: GestureDetector(
    //                     onTap: () async {
    //                       await pickDateRange(context);
    //                       // Refresh UI when dates are selected
    //                       (context as Element).markNeedsBuild();
    //                     },
    //                     child: Container(
    //                       padding: const EdgeInsets.all(12.0),
    //                       decoration: BoxDecoration(
    //                         color: Colors.white,
    //                         borderRadius: BorderRadius.circular(8),
    //                       ),
    //                       child: Text(
    //                         startDate != null
    //                             ? DateFormat('yyyy/MM/dd').format(startDate!)
    //                             : 'Start Date',
    //                         style: TextStyle(color: Colors.grey),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 const SizedBox(width: 10),
    //                 // End Date
    //                 Expanded(
    //                   child: GestureDetector(
    //                     onTap: () async {
    //                       await pickDateRange(context);
    //                       // Refresh UI when dates are selected
    //                       (context as Element).markNeedsBuild();
    //                     },
    //                     child: Container(
    //                       padding: const EdgeInsets.all(12.0),
    //                       decoration: BoxDecoration(
    //                         color: Colors.white,
    //                         borderRadius: BorderRadius.circular(8),
    //                       ),
    //                       child: Text(
    //                         endDate != null
    //                             ? DateFormat('yyyy/MM/dd').format(endDate!)
    //                             : 'End Date',
    //                         style: TextStyle(color: Colors.grey),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             SizedBox(height: 20),
    //             SizedBox(
    //               width: _deviceWidth! * 0.9,
    //               child: ElevatedButton(
    //                 onPressed: () {
    //                   _getReservation(DateFormat('yyyy-MM-dd').format(startDate!),
    //                       DateFormat('yyyy-MM-dd').format(endDate!));
    //                 },
    //                 style: ElevatedButton.styleFrom(
    //                   backgroundColor: Color.fromARGB(255, 224, 238, 238),
    //                   shape: RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.circular(32),
    //                     side: BorderSide(
    //                         color: Color.fromARGB(255, 37, 135, 134), width: 2),
    //                   ),
    //                   padding: EdgeInsets.symmetric(
    //                       horizontal: _deviceWidth! * 0.2,
    //                       vertical: _deviceHeight! * 0.02),
    //                 ),
    //                 child: Text(
    //                   'Check Availibility',
    //                   style: TextStyle(
    //                       fontSize: _deviceWidth! * 0.05,
    //                       color: const Color.fromARGB(255, 0, 0, 0)),
    //                 ),
    //               ),
    //             ),
    //             SizedBox(
    //               height: _deviceHeight! * 0.03,
    //             ),
    //             _resaultText(),
    //             SizedBox(
    //               height: _deviceHeight! * 0.03,
    //             ),
    //             _priceContainer(),
    //             SizedBox(
    //               height: _deviceHeight! * 0.02,
    //             ),
    //             _rentNowBtn()
    //           ],
    //         ),
    //       );
    //     },
    //   );
    // }

    // Widget _resaultText() {
    //   return Text(
    //     resualtText,
    //     style: TextStyle(
    //         color: Colors.red, fontSize: 15, fontWeight: FontWeight.w700),
    //   );
    // }

    // Widget _priceContainer() {
    //   return Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       Container(
    //         width: _deviceWidth! * 0.5,
    //         height: _deviceHeight! * 0.08,
    //         decoration: BoxDecoration(
    //           color: Color.fromARGB(255, 224, 238, 238),
    //           border:
    //               Border.all(color: Color.fromARGB(255, 37, 135, 134), width: 2),
    //           borderRadius: BorderRadius.circular(32),
    //         ),
    //         child: Center(
    //             child: Text(
    //           'LKR ${price}',
    //           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    //         )),
    //       ),
    //       _qtyContainer(),
    //     ],
    //   );
    // }

    // Widget _qtyContainer() {
    //   return Container(
    //     width: _deviceWidth! * 0.35,
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         Container(
    //           width: _deviceHeight! * 0.06,
    //           height: _deviceHeight! * 0.06,
    //           decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(100),
    //               color: Color.fromARGB(255, 37, 135, 134)),
    //           child: Center(
    //             child: Icon(
    //               Icons.remove,
    //               size: 40,
    //               color: Colors.white,
    //             ),
    //           ),
    //         ),
    //         Text(
    //           qty.toString(),
    //           style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    //         ),
    //         Container(
    //           width: _deviceHeight! * 0.06,
    //           height: _deviceHeight! * 0.06,
    //           decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(100),
    //               color: Color.fromARGB(255, 37, 135, 134)),
    //           child: Center(
    //             child: Icon(
    //               Icons.add,
    //               size: 40,
    //               color: Colors.white,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    // Widget _rentNowBtn() {
    //   return Center(
    //     child: SizedBox(
    //       width: _deviceWidth! * 0.9,
    //       child: ElevatedButton(
    //         onPressed: () {
    //           showBottomBar(context);
    //         },
    //         style: ElevatedButton.styleFrom(
    //           backgroundColor: const Color(0xFF238688),
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(32),
    //           ),
    //           padding: EdgeInsets.symmetric(
    //               horizontal: _deviceWidth! * 0.2,
    //               vertical: _deviceHeight! * 0.02),
    //         ),
    //         child: Text(
    //           'Rent now',
    //           style:
    //               TextStyle(fontSize: _deviceWidth! * 0.05, color: Colors.white),
    //         ),
    //       ),
    //     ),
    //   );
    // }

    // void _getReservation(String startDate, String endDate) async {
    //   Map<String, dynamic> data = await ProductClass().getAvailableProducts(
    //       startDate, endDate, widget.itemDetails['productId']);
    //   if (await int.parse(data['availableQuantity'].toString()) > 0) {
    //     setState(() {
    //       resualtText =
    //           "${data['availableQuantity'].toString()} items Available for these days";
    //       canRent = true;
    //       itemLimit = int.parse(data['availableQuantity'].toString());
    //     });
    //   } else {
    //     resualtText = "No items Available for these days";
    //     canRent = true;
    //     itemLimit = 1;
    //   }
    // }
  }
}
