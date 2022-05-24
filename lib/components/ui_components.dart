import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UIComponents{
  static Widget showText({required String title, required String body}){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.white, width: 1
          ),
          borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
            style: GoogleFonts.overlock(
              color: Colors.white
            ),
          ),
          Text(body,
            style: GoogleFonts.overlock(
              fontWeight: FontWeight.bold,
                color: Colors.white
            ),
          ),
        ],
      ),
    );
  }
}