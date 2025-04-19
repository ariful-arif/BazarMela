import 'dart:io';

import 'package:bazarmela/view/Role/Admin/Models/add_items_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final addItemProvider = StateNotifierProvider<AddItemNotifier, AddItemsState>((
  ref,
) {
  return AddItemNotifier();
});

class AddItemNotifier extends StateNotifier<AddItemsState> {
  AddItemNotifier() : super(AddItemsState()) {
    fetchCategory();
  }
  final CollectionReference items = FirebaseFirestore.instance.collection(
    "items",
  );
  final CollectionReference categoriesCollection = FirebaseFirestore.instance
      .collection("Category");

  void pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        state = state.copyWith(imagePath: pickedFile.path);
      }
    } catch (e) {
      throw Exception("Error saving item:$e");
    }
  }

  void setSelectedCategory(String? category) {
    state = state.copyWith(selectedCategory: category);
  }

  void addSize(String size) {
    state = state.copyWith(sizes: [...state.sizes, size]);
  }

  void removeSize(String? size) {
    state = state.copyWith(
      sizes: [...state.sizes.where((s) => s != size).toList()],
    );
  }

  void addColor(String color) {
    state = state.copyWith(colors: [...state.colors, color]);
  }

  void removeColor(String color) {
    state = state.copyWith(
      colors: [...state.colors.where((s) => s != color).toList()],
    );
  }

  void toggleDiscount(bool? isDiscounted) {
    state = state.copyWith(isDiscounted: isDiscounted);
  }

  void setDiscountPercentage(String? percentage) {
    state = state.copyWith(discountPercentage: percentage);
  }

  void setLoading(bool? isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  Future<void> fetchCategory() async {
    try {
      QuerySnapshot snapshot = await categoriesCollection.get();
      List<String> categories =
          snapshot.docs.map((doc) => doc['name'] as String).toList();
      state = state.copyWith(categories: categories);
    } catch (e) {
      throw Exception("Error saving item:$e");
    }
  }

  Future<void> uploadAndSave(String name, String price) async {
    if (name.isEmpty ||
        price.isEmpty ||
        state.imagePath == null ||
        state.selectedCategory == null ||
        state.sizes.isEmpty ||
        state.colors.isEmpty ||
        (state.isDiscounted && state.discountPercentage == null)) {
      throw Exception("Please fill all the feild an upload an image");
    }
    state = state.copyWith(isLoading: true);
    try {
      final fileName = DateTime.now().microsecondsSinceEpoch.toString();
      final refrence = FirebaseStorage.instance.ref().child("image/$fileName");
      await refrence.putFile(File(state.imagePath!));
      final imageUrl = await refrence.getDownloadURL();

      final String uid = FirebaseAuth.instance.currentUser!.uid;
      await items.add({
        'name': name,
        'price': int.tryParse(price),
        'imageUrl': imageUrl,
        'uploadedBy': uid,
        'category': state.selectedCategory,
        'size': state.sizes,
        'fcolor': state.colors,
        'isDiscounted': state.isDiscounted,
        'discountPercentage':
            state.isDiscounted ? int.tryParse(state.discountPercentage!) : 0,
      });
      state = AddItemsState();
    } catch (e) {
      throw Exception("Error saving item:$e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // }
}
