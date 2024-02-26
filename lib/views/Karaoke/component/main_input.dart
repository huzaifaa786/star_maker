// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

import 'package:gradient_borders/gradient_borders.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    this.controller,
    // this.hint,
    this.obscure = false,
    this.maxlines = 1,
    this.readOnly = false,
    this.lable,
    this.validator,
    this.autovalidateMode,
    this.type = TextInputType.text,
  }) : super(key: key);

  final controller;
  final validator;
  final obscure;
  //final hint;
  final type;
  final lable;
  final autovalidateMode;
  final maxlines;
  final readOnly;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 15, left: 0, right: 0),
        
        child: TextFormField(
            readOnly: readOnly,
            maxLines: maxlines,
            obscureText: obscure,
            controller: controller,
            validator: validator,
            //initialValue: 'Initial text here',

            // autovalidateMode: autovalidateMode ??
            //     (validator == true.obs
            //         ? AutovalidateMode.always
            //         : AutovalidateMode.onUserInteraction),
            style: TextStyle(color: Colors.black),
            keyboardType: type,
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric( horizontal: 30),
                // contentPadding: EdgeInsets.zero,
                
                floatingLabelBehavior: FloatingLabelBehavior.always,
                
                fillColor: Colors.white,
                border: GradientOutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomLeft,
                      colors: [Colors.purpleAccent, Colors.blue]),
                  width: 1,
                ),
                hoverColor: Colors.grey,
                focusColor: Colors.grey,
                labelText: lable,
                //hintText: hint,
                labelStyle: TextStyle(
                  
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    foreground: Paint()
                    
                      ..shader = LinearGradient(
                        
                              begin: Alignment.topLeft,
                              end: Alignment.bottomLeft,
                              colors: [Colors.purpleAccent, Colors.blue])
                              
                          .createShader(Rect.fromLTWH(0, 0, 200, 20),
                          
                          ))
                          
                          )));
  }
}
