import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../cubit/auth_cubit.dart';
import '../../../../generated/l10n.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

// ignore: must_be_immutable
class OtpWidget extends StatefulWidget {
  const OtpWidget({
    super.key,
    required this.title,
    required this.description,
    required this.onOtpCompleted,
  });
  final String title;
  final String description;
  final Function(String) onOtpCompleted;

  @override
  State<OtpWidget> createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {
  String otpCode = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.title,
          style: context.headlineLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: MyColors.primaryShade900,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: MySizes.spaceSm(context),
        ), // Space between title and description
        Text(
          widget.description,
          style: context.titleMedium.copyWith(fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: MySizes.spaceMd(context),
        ), // Space before the OTP fields
        PinCodeTextField(
          backgroundColor: Colors.transparent,
          length: 6,
          enableActiveFill: true,
          appContext: context,
          textStyle: context.headlineMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: MyColors.primaryShade900,
          ),

          keyboardType: TextInputType.number,
          animationType: AnimationType.fade,
          cursorColor: MyColors.primaryColor,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(8),
            fieldHeight: MySizes.iconLarge(context) * 1.2,
            fieldWidth: MySizes.iconLarge(context) * 1.2,
            fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 0.5),
            activeFillColor: Colors.transparent,
            activeColor: MyColors.primaryShade500,
            inactiveColor: Colors.grey.shade600,
            selectedColor: MyColors.primaryShade500,
            inactiveFillColor: Colors.transparent,
            selectedFillColor: Colors.transparent,
            borderWidth: MySizes.spaceXs(context) * 1.2,
          ),
          onChanged: (value) => {
            setState(() {
              if (value.length < 6) {
                otpCode = value;
              }
            }),
          },
          onCompleted: (value) {
            setState(() {
              otpCode = value;
            });
            widget.onOtpCompleted(value);
          },
        ),
        SizedBox(height: MySizes.spaceLg(context)),
      ],
    );
  }
}
