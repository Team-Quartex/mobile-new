import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trova/class/product_class.dart';

class BottomBar extends StatefulWidget {
  final Map<String, dynamic> itemDetails;
  final Function(String, bool, int) onReservationResult;
  const BottomBar({
    super.key,
    required this.itemDetails,
    required this.onReservationResult,
  });

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  DateTime? startDate;
  DateTime? endDate;
  String resultText = "";
  bool canRent = false;
  int qty = 1;
  int itemLimit = 1;
  double price = 0;
  double totPrice = 0;
  double? _deviceHeight, _deviceWidth;

  @override
  void initState() {
    super.initState();
    price = double.parse(widget.itemDetails['price'].toString());
    totPrice = price;
  }

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
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
    }
  }

  void _getReservation() async {
    if (startDate != null && endDate != null) {
      Map<String, dynamic> data = await ProductClass().getAvailableProducts(
        DateFormat('yyyy-MM-dd').format(startDate!),
        DateFormat('yyyy-MM-dd').format(endDate!),
        widget.itemDetails['productId'],
      );

      setState(() {
        if (int.parse(data['availableQuantity'].toString()) > 0) {
          resultText =
              "${data['availableQuantity']} items available for these days.";
          canRent = true;
          itemLimit = int.parse(data['availableQuantity'].toString());
        } else {
          resultText = "No items available for these days.";
          canRent = false;
          itemLimit = 1;
          qty = 1;
        }

        widget.onReservationResult(resultText, canRent, itemLimit);
      });
    }
  }

  void _reservationAdd() async {
    if (await ProductClass().addReservation(
        int.parse(widget.itemDetails['productId'].toString()),
        qty,
        DateFormat('yyyy-MM-dd').format(startDate!),
        DateFormat('yyyy-MM-dd').format(endDate!))) {
      Navigator.pop(context);
    } else {
      print("Eroor");
    }
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      height: _deviceHeight! * 0.6,
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 224, 238, 238),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(34),
          topRight: Radius.circular(34),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(
            thickness: 5,
            height: 40,
            indent: 150,
            endIndent: 150,
            color: Color.fromARGB(255, 161, 161, 161),
          ),
          const Text(
            "Check Availability",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Start Date
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    await pickDateRange(context);
                    // Refresh UI when dates are selected
                    (context as Element).markNeedsBuild();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      startDate != null
                          ? DateFormat('yyyy/MM/dd').format(startDate!)
                          : 'Start Date',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // End Date
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    await pickDateRange(context);
                    // Refresh UI when dates are selected
                    (context as Element).markNeedsBuild();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      endDate != null
                          ? DateFormat('yyyy/MM/dd').format(endDate!)
                          : 'End Date',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: _deviceWidth! * 0.9,
            child: ElevatedButton(
              onPressed: () {
                if (startDate != null && endDate != null) {
                  _getReservation();
                } else {
                  setState(() {
                    resultText = "Select date range!";
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 224, 238, 238),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                  side: const BorderSide(
                      color: Color.fromARGB(255, 37, 135, 134), width: 2),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: _deviceWidth! * 0.2,
                    vertical: _deviceHeight! * 0.02),
              ),
              child: Text(
                'Check Availibility',
                style: TextStyle(
                    fontSize: _deviceWidth! * 0.05,
                    color: const Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ),
          SizedBox(
            height: _deviceHeight! * 0.03,
          ),
          _resaultText(),
          SizedBox(
            height: _deviceHeight! * 0.03,
          ),
          _priceContainer(),
          SizedBox(
            height: _deviceHeight! * 0.02,
          ),
          _rentNowBtn()
        ],
      ),
    );
  }

  Widget _resaultText() {
    return Text(
      resultText,
      style: const TextStyle(
          color: Colors.red, fontSize: 15, fontWeight: FontWeight.w700),
    );
  }

  Widget _priceContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: _deviceWidth! * 0.5,
          height: _deviceHeight! * 0.08,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 224, 238, 238),
            border: Border.all(
                color: const Color.fromARGB(255, 37, 135, 134), width: 2),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Center(
              child: Text(
            'LKR $totPrice',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          )),
        ),
        _qtyContainer(),
      ],
    );
  }

  Widget _qtyContainer() {
    return SizedBox(
      width: _deviceWidth! * 0.35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              if (qty > 1) {
                setState(() {
                  qty--;
                  totPrice = price * qty;
                });
              }
            },
            child: Container(
              width: _deviceHeight! * 0.06,
              height: _deviceHeight! * 0.06,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color.fromARGB(255, 37, 135, 134)),
              child: const Center(
                child: Icon(
                  Icons.remove,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Text(
            qty.toString(),
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () {
              if (qty < itemLimit) {
                setState(() {
                  qty++;
                  totPrice = price * qty;
                });
              }
            },
            child: Container(
              width: _deviceHeight! * 0.06,
              height: _deviceHeight! * 0.06,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color.fromARGB(255, 37, 135, 134)),
              child: const Center(
                child: Icon(
                  Icons.add,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rentNowBtn() {
    return Center(
      child: SizedBox(
        width: _deviceWidth! * 0.9,
        child: ElevatedButton(
          onPressed: () {
            if (startDate != null && endDate != null) {
              _reservationAdd();
            }
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
            style:
                TextStyle(fontSize: _deviceWidth! * 0.05, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
