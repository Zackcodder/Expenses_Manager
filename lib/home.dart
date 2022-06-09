// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:eem/Login.dart';
import 'package:eem/ProfilePage.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:expandable/expandable.dart';
import 'package:eem/data_body.dart';
import 'package:eem/dummy_data.dart';
import 'package:eem/expanded_filter.dart';
import 'package:eem/expense_manager.dart';
import 'package:flutter/services.dart';
import 'package:expandable/expandable.dart';
import 'package:eem/textfield_decoration.dart';
import 'package:image_picker/image_picker.dart';
//this is my own package import

enum SortBy {
  dateAsc,
  dateDes,
  merchantAsc,
  merchantDes,
  totalAsc,
  totalDes,
  statusAsc,
  statusDes,
  commentAsc,
  commentDes,
  none
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  List<String> merchants = [
    "Electronics",
    "Breakfast",
    "Airline",
    "Parking",
    "Taxi",
    "Shuttle",
    "Fast Food",
    "Office Supplies",
    "Rental Car",
    "Ride Sharing",
    "Restaurant",
    "Hotel"
  ];
  

  String? selectedItem;

  TextEditingController customController = TextEditingController();
  late LinkedScrollControllerGroup controllerGroup;
  late ScrollController controller;
  late ScrollController controller2;
  bool showBorder = false;
  late List<ExpenseManager> data;
  late List<ExpenseManager> data2;
  SortBy sortBy = SortBy.none;
  double total = 0.0;

   String image = "";

  late PickedFile _imageFile;

  final ImagePicker _picker = ImagePicker();


  @override
  void initState() {
    controllerGroup = LinkedScrollControllerGroup();
    controller = controllerGroup.addAndGet();
    controller2 = controllerGroup.addAndGet();
    data = dummyData;
    calculateTotal();
    dateSort();

    controller.addListener(() {
      setState(() {
        showBorder = controller.offset != 0;
      });
    });

    super.initState();
  }

  calculateTotal() {
    data.where((element) {
      return element.status == "New";
    }).forEach((element) {
      total = total + element.total;
    });
    setState(() {});
  }

  dateSort() {
    if (sortBy != SortBy.dateDes && sortBy != SortBy.dateAsc) {
      setState(() {
        sortBy = SortBy.dateAsc;
        data.sort((a, b) {
          return a.date.toString().compareTo(b.date.toString());
        });
      });
    } else if (sortBy == SortBy.dateAsc && sortBy != SortBy.dateDes) {
      setState(() {
        data.sort((b, a) {
          sortBy = SortBy.dateDes;
          return a.date.toString().compareTo(b.date.toString());
        });
      });
    } else {
      setState(() {
        sortBy = SortBy.none;
        data.sort((a, b) {
          return a.date.toString().compareTo(a.date.toString());
        });
      });
    }
  }

  merchantSort() {
    if (sortBy != SortBy.merchantDes && sortBy != SortBy.merchantAsc) {
      setState(() {
        sortBy = SortBy.merchantAsc;
        data.sort((a, b) {
          return a.merchant.compareTo(b.merchant);
        });
      });
    } else if (sortBy == SortBy.merchantAsc && sortBy != SortBy.merchantDes) {
      setState(() {
        data.sort((b, a) {
          sortBy = SortBy.merchantDes;
          return a.merchant.compareTo(b.merchant);
        });
      });
    } else {
      setState(() {
        sortBy = SortBy.none;
        data.sort((a, b) {
          return a.date.toString().compareTo(a.date.toString());
        });
      });
    }
  }

  totalSort() {
    if (sortBy != SortBy.totalAsc && sortBy != SortBy.totalDes) {
      setState(() {
        sortBy = SortBy.totalAsc;
        data.sort((a, b) {
          return a.total.toString().compareTo(b.total.toString());
        });
      });
    } else if (sortBy == SortBy.totalAsc && sortBy != SortBy.totalDes) {
      setState(() {
        data.sort((b, a) {
          sortBy = SortBy.totalDes;
          return a.total.toString().compareTo(b.total.toString());
        });
      });
    } else {
      setState(() {
        sortBy = SortBy.none;
        data.sort((a, b) {
          return a.date.toString().compareTo(a.date.toString());
        });
      });
    }
  }

  statusSort() {
    if (sortBy != SortBy.statusDes && sortBy != SortBy.statusAsc) {
      setState(() {
        sortBy = SortBy.statusAsc;
        data.sort((a, b) {
          return a.status.compareTo(b.status);
        });
      });
    } else if (sortBy == SortBy.statusAsc && sortBy != SortBy.statusDes) {
      setState(() {
        data.sort((b, a) {
          sortBy = SortBy.statusDes;
          return a.status.compareTo(b.status);
        });
      });
    } else {
      setState(() {
        sortBy = SortBy.none;
        data.sort((a, b) {
          return a.date.toString().compareTo(a.date.toString());
        });
      });
    }
  }

  commentSort() {
    if (sortBy != SortBy.commentDes && sortBy != SortBy.commentAsc) {
      setState(() {
        sortBy = SortBy.commentAsc;
        data.sort((a, b) {
          return a.comment.compareTo(b.comment);
        });
      });
    } else if (sortBy == SortBy.commentAsc && sortBy != SortBy.commentDes) {
      setState(() {
        data.sort((b, a) {
          sortBy = SortBy.commentDes;
          return a.comment.compareTo(b.comment);
        });
      });
    } else {
      setState(() {
        sortBy = SortBy.none;
        data.sort((a, b) {
          return a.date.toString().compareTo(a.date.toString());
        });
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    controller2.dispose();
    super.dispose();
  }

  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            content: SizedBox(
              height: 200,
              width: 1200.0,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 130),
                      child: Title(
                          color: Colors.white,
                          child: Text(
                            "Add Expense",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ),
                    // For Merchant

                     Padding(
                      padding: const EdgeInsets.only(right: 150, top: 10),
                      child: const Text(
                     "Merchant",
                     style: TextStyle(
                     fontSize: 17,
                     color: Colors.black54,
                     fontWeight: FontWeight.w500,
                      ),
                      ),
                    ),

                     
                    SizedBox(
              height: 40,
              child: DropdownButtonFormField<String>(
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                items: merchants.map((merchant) {
                  return DropdownMenuItem<String>(
                    child: Text(merchant),
                    value: merchant,
                  );
                }).toList(),
                onChanged: (item) {
                  setState(() {
                    selectedItem = item;
                  });
                },
                decoration: decoration,
                value: selectedItem,
              ),
            ),
            

                    // For Total
                   Padding(
                      padding: const EdgeInsets.only(right: 160, top: 10),
                      child: const Text(
                     "Total",
                     style: TextStyle(
                     fontSize: 17,
                     color: Colors.black54,
                     fontWeight: FontWeight.w500,
                      ),
                      ),
                    ),
                    SizedBox(
                        height: 35,
                        child: TextField(
                          onTap: () {},
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          cursorColor: Colors.black12,
                          style: const TextStyle(fontSize: 20, height: 1.4),
                          cursorHeight: 24,
                          cursorWidth: 1,
                          decoration: decoration.copyWith(
                            isDense: true,
                            prefixIconConstraints:
                                const BoxConstraints(minWidth: 25),
                            prefixIcon: const Text(
                              r" $",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),

                    // Date Section
                  Padding(
                      padding: const EdgeInsets.only(right: 160, top: 10),
                      child: const Text(
                     "Date",
                     style: TextStyle(
                     fontSize: 17,
                     color: Colors.black54,
                     fontWeight: FontWeight.w500,
                      ),
                      ),
                    ),
            const SizedBox(height: 5),
            SizedBox(
              height: 40,
              child: TextField(
                readOnly: true,
                onTap: () {},
                decoration: decoration.copyWith(
                  suffixIcon: const Icon(Icons.calendar_month_rounded),
                ),
              ),
            ),
                    //  For Comment Section
                    Padding(
                      padding: const EdgeInsets.only(right: 150, top: 10),
                      child: Text("Comment"),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.grey.withOpacity(0.5),
                        child: TextFormField(
                          controller: customController,
                          decoration: const InputDecoration(),
                        ),
                      ),
                    ),
                  // For Uploading Reciept
                    Padding(
                      padding: const EdgeInsets.only(right: 100),
                      child: MaterialButton(
                          onPressed: () {
                            takePhoto(ImageSource.gallery);
                          },
                          color: Colors.grey,
                          minWidth: 30,
                          child: Text("Upload receipt")),
                    )
                  ],
                ),
              ),
            ),
            actions: [
              MaterialButton(
                  minWidth: 30.0,
                  color: Colors.blue,
                  elevation: 10.0,
                  child: Text("Save"),
                  onPressed: () {}),
              MaterialButton(
                  minWidth: 30.0,
                  color: Colors.white,
                  elevation: 10.0,
                  child: Text("Cancel"),
                  onPressed: () {
                    
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                  }),
              MaterialButton(
                  minWidth: 30.0,
                  elevation: 10.0,
                  child: Text("Delete"),
                  onPressed: () {}),
            ],
          );
        });
  }

void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);
    _imageFile = pickedFile!;
    if (_imageFile.path != null) {
      setState(() {
        image = _imageFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        shadowColor: Colors.transparent,
        title: Center(
          child: Text(
            'Expense Manager',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            },
            child: Text(
              'Info',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SignIn()));
            },
            icon: Icon(
              Icons.logout_sharp,
              color: Colors.blue,
              size: 27,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            ExpandableNotifier(
              child: Expandable(
                collapsed: Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 10, right: 20),
                  color: const Color(0xfff4f5f7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "To be reimbursed",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 13.5),
                          children: [
                            TextSpan(
                              text: "\n\$$total",
                              style: const TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                      ExpandableButton(
                          child: Row(
                        children: const [
                          Text(
                            "Filters",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.sort,
                            color: Colors.blue,
                            size: 26,
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
                expanded: ExpandedFilter(total: total),
              ),
            ),
            Container(
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, -2),
                    spreadRadius: 0,
                    blurRadius: 2,
                    color: Colors.black38,
                  ),
                ],
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: Colors.black38,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: dateSort,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Text(
                            'Date',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: sortBy == SortBy.dateAsc ||
                                        sortBy == SortBy.dateDes
                                    ? Colors.blue
                                    : Colors.black),
                          ),
                          Icon(
                            sortBy == SortBy.dateAsc
                                ? Icons.arrow_drop_down
                                : sortBy == SortBy.dateDes
                                    ? Icons.arrow_drop_up
                                    : Icons.unfold_more,
                            color: sortBy == SortBy.dateAsc ||
                                    sortBy == SortBy.dateDes
                                ? Colors.blue
                                : Colors.black38,
                          )
                        ],
                      ),
                      width: 100,
                      decoration: BoxDecoration(
                          border: BorderDirectional(
                              end: showBorder
                                  ? const BorderSide(
                                      color: Colors.black, width: 0.1)
                                  : BorderSide.none)),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: controller,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: merchantSort,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                    'Merchant',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: sortBy == SortBy.merchantAsc ||
                                                sortBy == SortBy.merchantDes
                                            ? Colors.blue
                                            : Colors.black),
                                  ),
                                  Icon(
                                    sortBy == SortBy.merchantAsc
                                        ? Icons.arrow_drop_down
                                        : sortBy == SortBy.merchantDes
                                            ? Icons.arrow_drop_up
                                            : Icons.unfold_more,
                                    color: sortBy == SortBy.merchantAsc ||
                                            sortBy == SortBy.merchantDes
                                        ? Colors.blue
                                        : Colors.black38,
                                  )
                                ],
                              ),
                              width: 100,
                            ),
                          ),
                          GestureDetector(
                            onTap: totalSort,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                    'Total',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: sortBy == SortBy.totalAsc ||
                                                sortBy == SortBy.totalDes
                                            ? Colors.blue
                                            : Colors.black),
                                  ),
                                  Icon(
                                    sortBy == SortBy.totalAsc
                                        ? Icons.arrow_drop_down
                                        : sortBy == SortBy.totalDes
                                            ? Icons.arrow_drop_up
                                            : Icons.unfold_more,
                                    color: sortBy == SortBy.totalAsc ||
                                            sortBy == SortBy.totalDes
                                        ? Colors.blue
                                        : Colors.black38,
                                  )
                                ],
                              ),
                              width: 100,
                            ),
                          ),
                          GestureDetector(
                            onTap: statusSort,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                    'Status',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: sortBy == SortBy.statusAsc ||
                                                sortBy == SortBy.statusDes
                                            ? Colors.blue
                                            : Colors.black),
                                  ),
                                  Icon(
                                    sortBy == SortBy.statusAsc
                                        ? Icons.arrow_drop_down
                                        : sortBy == SortBy.statusDes
                                            ? Icons.arrow_drop_up
                                            : Icons.unfold_more,
                                    color: sortBy == SortBy.statusAsc ||
                                            sortBy == SortBy.statusDes
                                        ? Colors.blue
                                        : Colors.black38,
                                  )
                                ],
                              ),
                              width: 100,
                            ),
                          ),
                          GestureDetector(
                            onTap: commentSort,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                    'Comment',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: sortBy == SortBy.commentAsc ||
                                                sortBy == SortBy.commentDes
                                            ? Colors.blue
                                            : Colors.black),
                                  ),
                                  Icon(
                                    sortBy == SortBy.commentAsc
                                        ? Icons.arrow_drop_down
                                        : sortBy == SortBy.commentDes
                                            ? Icons.arrow_drop_up
                                            : Icons.unfold_more,
                                    color: sortBy == SortBy.commentAsc ||
                                            sortBy == SortBy.commentDes
                                        ? Colors.blue
                                        : Colors.black38,
                                  )
                                ],
                              ),
                              width: 150,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: DataBody(
                controller2,
                data: data,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(40.0),
        child: FloatingActionButton(
          onPressed: () {
            createAlertDialog(context);
          },
          backgroundColor: Color.fromARGB(255, 221, 8, 8),
          child: Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }


}
