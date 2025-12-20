import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nostrrdr/src/app/theme/app_colors.dart';
import 'package:nostrrdr/src/app/widgets/nr_icon_button.dart';

class NrTextField extends FormField<String> {
  NrTextField({
    super.key,
    this.textController,
    this.focusNode,
    this.padding,
    this.contentPadding,
    this.autofocus = false,
    this.hintText,
    this.obscureText = false,
    this.label,
    this.readOnly = false,
    this.maxLines = 1,
    this.onTap,
    this.leadingIcon,
    this.trailingIcon,
    super.validator,
  }) : super(
         builder: (FormFieldState<String> field) {
           final _NrTextFieldState state = field as _NrTextFieldState;
           final context = state.context;

           final borderSide = BorderSide(color: context.colors.surfaceVariant);
           final errorBorderSide = BorderSide(color: context.colors.error);

           final effectiveBorderSide = state.hasError
               ? errorBorderSide
               : borderSide;

           final borderRadius = BorderRadius.only(
             topLeft: leadingIcon != null
                 ? Radius.circular(2.r)
                 : Radius.circular(8.r),
             bottomLeft: leadingIcon != null
                 ? Radius.circular(2.r)
                 : Radius.circular(8.r),
             topRight: trailingIcon != null
                 ? Radius.circular(2.r)
                 : Radius.circular(8.r),
             bottomRight: trailingIcon != null
                 ? Radius.circular(2.r)
                 : Radius.circular(8.r),
           );

           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               if (label != null) ...[
                 Text(
                   label,
                   style: TextStyle(
                     color: context.colors.onBackground,
                     fontSize: 14.sp,
                     fontWeight: FontWeight.w500,
                   ),
                 ),
                 SizedBox(height: 8.h),
               ],
               Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   if (leadingIcon != null) ...[
                     NrIconButton(
                       onTap: leadingIcon.onTap,
                       icon: leadingIcon.icon,
                       type: NrIconButtonType.leading,
                       size: leadingIcon.size,
                       color: leadingIcon.color,
                       padding: EdgeInsets.symmetric(
                         horizontal: 12.w,
                         vertical: 13.5.h,
                       ),
                     ),
                     SizedBox(width: 4.w),
                   ],
                   Expanded(
                     child: TextField(
                       controller: state._effectiveController,
                       focusNode: focusNode,
                       onTap: onTap,
                       autofocus: autofocus,
                       obscureText: obscureText,
                       readOnly: readOnly,
                       maxLines: maxLines,
                       obscuringCharacter: '*',
                       onChanged: (value) {
                         field.didChange(value);
                       },
                       style: TextStyle(
                         color: context.colors.onBackground,
                         fontSize: 14.sp,
                         fontWeight: FontWeight.w700,
                       ),
                       decoration: InputDecoration(
                         hintText: hintText,
                         labelStyle: TextStyle(
                           color: context.colors.onBackground,
                           fontSize: 14.sp,
                         ),
                         hintStyle: TextStyle(
                           color: context.colors.onBackground,
                           fontSize: 14.sp,
                         ),
                         fillColor: context.colors.surface,
                         filled: true,
                         border: OutlineInputBorder(
                           borderSide: effectiveBorderSide,
                           borderRadius: borderRadius,
                         ),
                         enabledBorder: OutlineInputBorder(
                           borderSide: effectiveBorderSide,
                           borderRadius: borderRadius,
                         ),
                         focusedBorder: OutlineInputBorder(
                           borderSide: effectiveBorderSide,
                           borderRadius: borderRadius,
                         ),
                         contentPadding:
                             contentPadding ??
                             EdgeInsets.symmetric(
                               horizontal: 16.w,
                               vertical: 13.5.h,
                             ),
                       ),
                     ),
                   ),
                   if (trailingIcon != null) ...[
                     SizedBox(width: 4.w),
                     NrIconButton(
                       onTap: trailingIcon.onTap,
                       icon: trailingIcon.icon,
                       type: NrIconButtonType.trailing,
                       size: trailingIcon.size,
                       color: trailingIcon.color,
                       padding: EdgeInsets.symmetric(
                         horizontal: 12.w,
                         vertical: 13.5.h,
                       ),
                     ),
                   ],
                 ],
               ),
               if (state.hasError) ...[
                 SizedBox(height: 8.h),
                 Padding(
                   padding: EdgeInsets.only(left: 4.w),
                   child: Text(
                     state.errorText!,
                     style: TextStyle(
                       color: context.colors.error,
                       fontSize: 12.sp,
                     ),
                   ),
                 ),
               ],
             ],
           );
         },
       );

  final TextEditingController? textController;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;
  final bool autofocus;
  final String? hintText;
  final bool obscureText;
  final String? label;
  final bool readOnly;
  final int maxLines;
  final VoidCallback? onTap;
  final NrIconButton? leadingIcon;
  final NrIconButton? trailingIcon;

  @override
  FormFieldState<String> createState() => _NrTextFieldState();
}

class _NrTextFieldState extends FormFieldState<String> {
  TextEditingController? _controller;

  TextEditingController get _effectiveController =>
      widget.textController ?? _controller!;

  @override
  NrTextField get widget => super.widget as NrTextField;

  @override
  void initState() {
    super.initState();
    if (widget.textController == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      widget.textController!.addListener(_handleControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.textController?.removeListener(_handleControllerChanged);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChange(String? value) {
    super.didChange(value);
    if (_effectiveController.text != value) {
      _effectiveController.text = value ?? '';
    }
  }

  @override
  void reset() {
    _effectiveController.text = widget.initialValue ?? '';
    super.reset();
  }

  void _handleControllerChanged() {
    if (_effectiveController.text != value) {
      didChange(_effectiveController.text);
    }
  }
}
