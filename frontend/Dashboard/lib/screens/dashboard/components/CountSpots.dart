import 'package:flutter/cupertino.dart';

import '../../Pages/ChooseParkingSlotScreen.dart';

class Bird extends StatefulWidget {



  @override
  State<Bird> createState() => _BirdState();
}




class _BirdState extends State<Bird> {


  @override
  Widget build(BuildContext context) {
    return Text(ChooseParkingSlotScreen().count.toString());
  }
}


class Bird1 extends StatefulWidget {



  @override
  State<Bird1> createState() => _Bird1State();
}




class _Bird1State extends State<Bird1> {

int S=ChooseParkingSlotScreen().count+1;
  @override
  Widget build(BuildContext context) {
    return Text(S.toString());
  }
}