// ignore_for_file: file_names, must_be_immutable, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:splitit/const.dart';

class AppTextField extends StatelessWidget {
  TextEditingController? controller;
  String hint;
  String? label;
  TextInputType? inputType;
  bool isDatePicker;
  bool isTimePicker;
  List<String>? dropDownItems;
  TextInputFormatter? formatter;
  Function()? onTap;
  Function()? onChange;
  Icon? suffix;
  String? Function(String?)? validator;
  bool allowDateInPast;
  bool enabled;
  int? maxLength;
  DateTime? minDate;
  DateTime? maxDate;
  int? minLines;
  int? maxLines;

  AppTextField(
      {Key? key,
      this.controller,
      this.inputType,
      required this.hint,
      this.label,
      this.dropDownItems,
      this.onTap,
      this.onChange,
      this.suffix,
      this.isDatePicker = false,
      this.isTimePicker = false,
      this.formatter,
      this.validator,
      this.allowDateInPast = true,
      this.maxLength,
      this.minDate,
      this.maxDate,
      this.minLines,
      this.maxLines,
      this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return dropDownItems != null
        ? DropdownButtonFormField(
            validator: validator,
            value: controller!.text.isNotEmpty ? controller!.text : null,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: Colors.red),
              ),
              errorStyle: TextStyle(color: Colors.red),
            ),
            items: dropDownItems!.map((item) {
              return DropdownMenuItem(
                child: Text(item),
                value: item,
              );
            }).toList(),
            onChanged: enabled
                ? (value) {
                    controller!.text = value.toString();
                    onChange?.call();
                  }
                : null,
          )
        : InkWell(
            onTap: isDatePicker && enabled
                ? () {
                    showDatePicker(
                      context: context,
                      initialDate: maxDate != null ? maxDate! : DateTime.now(),
                      firstDate: minDate != null
                          ? minDate!
                          : allowDateInPast
                              ? DateTime(1900)
                              : DateTime.now(),
                      lastDate: maxDate != null ? maxDate! : DateTime(2100),
                    ).then((date) {
                      if (date != null && controller != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(date);
                        controller!.text = formattedDate;
                      }
                    });
                  }
                : isTimePicker && enabled
                    ? () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate:
                              allowDateInPast ? DateTime(1900) : DateTime.now(),
                          lastDate: DateTime(2100),
                        ).then((date) {
                          showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now())
                              .then((time) {
                            if (date != null && controller != null) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(date);
                              controller!.text = formattedDate +
                                  ' ' +
                                  time!.hour.toString() +
                                  ':' +
                                  time.minute.toString() +
                                  ':00';
                            }
                          });
                        });
                      }
                    : onTap,
            child: TextFormField(
              validator: validator,
              maxLength: maxLength,
              minLines: minLines,
              maxLines: maxLines,
              keyboardType: inputType,
              controller: controller,
              enabled:
                  !isDatePicker && !isTimePicker && onTap == null && enabled,
              inputFormatters: formatter != null
                  ? [FilteringTextInputFormatter.digitsOnly, formatter!]
                  : null,
              decoration: InputDecoration(
                hintText: hint,
                label: label != null ? Text(label!) : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: Colors.red),
                ),
                errorStyle: TextStyle(color: Colors.red),
                suffixIcon: isDatePicker || isTimePicker
                    ? Icon(
                        Icons.calendar_today,
                        color: orangeColor,
                      )
                    : suffix,
              ),
            ),
          );
  }
}
