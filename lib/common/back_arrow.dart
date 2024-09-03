import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackArrow extends StatefulWidget {
  final Function() onPressed;
  const BackArrow({super.key,required this.onPressed});

  @override
  State<BackArrow> createState() => _BackArrowState();
}

class _BackArrowState extends State<BackArrow> {
  @override
  Widget build(BuildContext context) {
    return Container(padding: EdgeInsets.all(10.w),
      child: IconButton(onPressed: widget.onPressed, icon: Icon(Icons.arrow_back_ios_new,size: 10.sp,),
      style: Theme.of(context).iconButtonTheme.style?.copyWith(
        shape: const WidgetStatePropertyAll(CircleBorder())
      ),),
    );
  }
}

