import 'package:chatgenie/colors.dart';
import 'package:flutter/cupertino.dart';

class FeatureBox extends StatelessWidget {
  final Color color;
  final String headerText;
  final String descriptionText;
  const FeatureBox({
    super.key,
    required this.color,
    required this.headerText,
    required this.descriptionText
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 10,
      ),
      padding: const EdgeInsets.only(
        top: 15,
        bottom: 15,
        left: 15
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        )
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(headerText,style: const TextStyle(
              fontFamily: 'Cera Pro',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.blackColor,
            ),),
          ),
          const SizedBox(height: 3,),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(descriptionText,style: const TextStyle(
              fontFamily: 'Cera Pro',
              color: AppColor.blackColor,
            ),
            ),
          ),
        ],
      ),
    );
  }
}
