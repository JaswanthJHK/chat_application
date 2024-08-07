import 'package:chat_app_firebase/constants/sizes.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    required this.text,
    required this.ontap,
  });
  final String text;
  final void Function()? ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primaryFixedDim,
                ),
                Appsizes.sizeTwentyW,
                Text(
                  text,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryFixedDim),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
