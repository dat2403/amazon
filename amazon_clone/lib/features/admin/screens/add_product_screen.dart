import 'dart:io';
import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/custom_textfield.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  final _addProductFormKey = GlobalKey<FormState>();

  final AdminServices adminServices = AdminServices();

  List<String> productCategories = [
    'Mobiles',
    'Essentials',
    'Appliances',
    'Books',
    'Fashion'
  ];

  String category = 'Mobiles';

  List<File> images = [];

  void sellProduct() {
    if (_addProductFormKey.currentState!.validate() && images.isNotEmpty) {
      adminServices.sellProduct(
        context: context,
        name: _productNameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        quantity: double.parse(_quantityController.text),
        category: category,
        images: images,
      );
    }
  }

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _productNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          // App Bar ko có property làm linear gradient
          // Cần dùng flexiableSpace để truyền Container linear gradient
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: const Text(
            'Add Product',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addProductFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                images.isNotEmpty
                    ? CarouselSlider(
                        items: images.map((image) {
                          return Builder(
                            builder: (BuildContext context) => Image.file(
                              image,
                              fit: BoxFit.cover,
                              height: 200,
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: 200,
                        ),
                      )
                    : GestureDetector(
                        onTap: selectImages,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.folder_open,
                                  size: 40,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Select Product Images",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade400,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextField(
                  controller: _productNameController,
                  hintText: 'Product Name',
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  controller: _descriptionController,
                  hintText: 'Description',
                  maxLines: 7,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  controller: _priceController,
                  hintText: 'Price',
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  controller: _quantityController,
                  hintText: 'Quantity',
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    items: productCategories.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    value: category,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    onChanged: (String? value) {
                      setState(() {
                        category = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomButton(
                  title: "Sell",
                  onTap: sellProduct,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
