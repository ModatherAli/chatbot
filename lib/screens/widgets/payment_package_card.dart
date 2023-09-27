import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PaymentPackageCard extends StatefulWidget {
  final String title;
  final String desc;
  final Package? package;
  const PaymentPackageCard({
    super.key,
    required this.isSelected,
    this.onTap,
    required this.title,
    required this.desc,
    required this.package,
  });
  final bool isSelected;
  final void Function()? onTap;

  @override
  State<PaymentPackageCard> createState() => _PaymentPackageCardState();
}

class _PaymentPackageCardState extends State<PaymentPackageCard>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  double _opacity = 0.5;

  @override
  Widget build(BuildContext context) {
    _opacity = 0.5;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _opacity = 1;
    });
    // _animationController!.repeat().whenCompleteOrCancel(() {
    //   _opacity = 1;
    // });
    return Expanded(
      child: AnimatedOpacity(
        duration: const Duration(seconds: 1),
        opacity: widget.isSelected ? 1 : 0.7,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            height: 180,
            width: 100,
            padding: widget.isSelected
                ? const EdgeInsets.all(3)
                : const EdgeInsets.all(5),
            margin: const EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              border: widget.isSelected
                  ? Border.all(color: const Color(0xFFffb703), width: 2)
                  : null,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(7),
                    gradient: widget.isSelected
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFffbe0b),
                              Color(0xFFffb703),
                              Color(0xFFfb8500),
                            ],
                          )
                        : null,
                  ),
                  child: Text(
                    widget.title.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: widget.isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  widget.package == null
                      ? '9.99 \$'
                      : '${widget.package!.storeProduct.price} ${widget.package!.storeProduct.currencyCode}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                ),
                Text(
                  widget.desc.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
