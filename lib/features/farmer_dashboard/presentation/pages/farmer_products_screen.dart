import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FarmerProductsScreen extends ConsumerStatefulWidget {
  const FarmerProductsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FarmerProductsScreenState();
}

class _FarmerProductsScreenState extends ConsumerState<FarmerProductsScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Farmer Products Screen")),
    );
  }
}