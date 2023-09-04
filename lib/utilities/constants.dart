import 'package:flutter/material.dart';

const kBiollaveBlue = Color(0xFF608EC6);
const kBiollaveBlueLight = Color(0xFFbfd1e8);
const kBiollaveOrange = Color(0xFFE26416);
const kBiollaveOrangeLight = Color(0xFFea925b);
const kBiollaveOrangeSuperLight = Color(0xFFf6d3bd);

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final kHintTextStyleBlue = TextStyle(
  color: Color(0xFF608EC6),
  fontFamily: 'OpenSans',
);

final kHintTextStyleWhite = TextStyle(
  color: Colors.white,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kLabelStyle2 = TextStyle(
  color: Color(0xFF608EC6),
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
  fontSize: 48,
);

final kLabelStyleBlue = TextStyle(
  color: Color(0xFF608EC6),
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kLabelStyleOrange = TextStyle(
  color: kBiollaveOrange,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Color(0xFF608EC6),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.shade200,
      blurRadius: 6.0,
      offset: Offset(0, 0),
    ),
  ],
);

final kBoxDecorationStyleOrange = BoxDecoration(
  color: kBiollaveOrangeLight,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.white,
      blurRadius: 6.0,
      offset: Offset(0, 0),
    ),
  ],
);

final kBoxDecorationStyleLight = BoxDecoration(
  color: Color(0xFFbfd1e8),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.shade200,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

final kBoxDecorationStyle2 = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
