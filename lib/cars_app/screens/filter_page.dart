import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FilterPage extends StatelessWidget {
  const FilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('filter_title'.tr())),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/results');
            },
            child: Text('apply_filters'.tr()),
          ),
        ],
      ),
    );
  }
}
