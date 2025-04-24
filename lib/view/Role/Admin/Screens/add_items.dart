import 'dart:io';

import 'package:bazarmela/Widgets/my_button.dart';
import 'package:bazarmela/Widgets/show_snackbar.dart';
import 'package:bazarmela/view/Role/Admin/Controller/add_items_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddItems extends ConsumerWidget {
  AddItems({super.key});

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _priceController = TextEditingController();

  final TextEditingController _sizeController = TextEditingController();

  final TextEditingController _colorController = TextEditingController();

  final TextEditingController _discountPercentageController =
      TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addItemProvider);
    final notifier = ref.read(addItemProvider.notifier);
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Add New Items")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      state.imagePath != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(state.imagePath!),
                              fit: BoxFit.cover,
                            ),
                          )
                          : state.isLoading
                          ? const CircularProgressIndicator()
                          : GestureDetector(
                            onTap: notifier.pickImage,
                            child: const Icon(Icons.camera_alt, size: 30),
                          ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: "Price",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: state.selectedCategory,
                decoration: InputDecoration(
                  labelText: "Select Category",
                  border: OutlineInputBorder(),
                ),
                items:
                    state.categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                onChanged: notifier.setSelectedCategory,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _sizeController,
                decoration: InputDecoration(
                  labelText: "Sizes (coma saperated)",
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  notifier.addSize(value);
                  _sizeController.clear();
                },
              ),
              Wrap(
                spacing: 8,
                children:
                    state.sizes
                        .map(
                          (size) => Chip(
                            label: Text(size),
                            onDeleted: () => notifier.removeSize(size),
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _colorController,
                decoration: InputDecoration(
                  labelText: "Color",
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  notifier.addColor(value);
                  _colorController.clear();
                },
              ),
              Wrap(
                spacing: 8,
                children:
                    state.colors
                        .map(
                          (color) => Chip(
                            label: Text(color),
                            onDeleted: () => notifier.removeColor(color),
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: state.isDiscounted,
                    onChanged: notifier.toggleDiscount,
                  ),
                  const Text("Apply Discount"),
                ],
              ),
              if (state.isDiscounted)
                Column(
                  children: [
                    TextField(
                      controller: _discountPercentageController,
                      decoration: InputDecoration(
                        labelText: "Discount Percentage (%)",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        notifier.setDiscountPercentage(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    state.isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Center(
                          child: MyButton(
                            label: "Save item",
                            onPressed: () async {
                              try {
                                await notifier.uploadAndSave(
                                  _nameController.text,
                                  _priceController.text,
                                );
                                showSnackbar(
                                  context,
                                  "Item added successfully",
                                );
                                Navigator.pop(context);
                              } catch (e) {
                                showSnackbar(context, "Error saving item: $e");
                              }
                            },
                            color: Colors.blueAccent,
                          ),
                        ),
                  ],
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
