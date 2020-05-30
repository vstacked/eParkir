import 'package:eparkir/main.dart';
import 'package:eparkir/utils/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstSlider extends StatefulWidget {
  @override
  _FirstSliderState createState() => _FirstSliderState();
}

class _FirstSliderState extends State<FirstSlider> {
  List<Slide> slides = new List();
  TxtStyle style = TxtStyle();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: 'Selamat Datang di eParkir',
        styleTitle: style.title.copyWith(
          fontSize: 25.0,
          color: Colors.white,
        ),
        maxLineTitle: 2,
        pathImage: "assets/images/logo2.png",
        colorBegin: Colors.teal[200],
        colorEnd: Colors.teal[400],
        directionColorBegin: Alignment.topRight,
        directionColorEnd: Alignment.bottomLeft,
      ),
    );
    slides.add(
      new Slide(
        title: 'Pengertian',
        styleTitle: style.title.copyWith(
          fontSize: 30.0,
          color: Colors.white,
        ),
        description:
            'eParkir adalah aplikasi scanner pengganti "karcis / tiket" saat masuk ke sekolah, menjadi lebih fleksibel dan efisien.',
        styleDescription: style.desc.copyWith(
          color: Colors.white,
          fontSize: 15.0,
        ),
        pathImage: "assets/images/logo2.png",
        colorBegin: Colors.teal[600],
        colorEnd: Colors.teal[300],
        directionColorBegin: Alignment.topRight,
        directionColorEnd: Alignment.bottomLeft,
      ),
    );
    slides.add(
      new Slide(
        title: 'Manfaat',
        styleTitle: style.title.copyWith(
          fontSize: 30.0,
          color: Colors.white,
        ),
        description:
            'Bagi murid, cara ini lebih efisien. Karena tidak ada ketakutan karcis / tiket itu hilang. Dan juga, aplikasi ini dijalankan di smartphone yang di jaman sekarang ini kebanyakan siswa telah memilikinya.\n\n Bagi petugas, cara ini bisa lebih cepat. Karena tidak perlu membawa karcis / tiket, dan mengambilnya lagi ketika sudah habis. Cukup dengan smartphone, bisa langsung menggunakan scan tanpa perlu repot-repot lagi. \n\n Jadi tunggu apalagi, ayo coba sekarang!!',
        styleDescription: style.desc.copyWith(
          color: Colors.white,
          fontSize: 15.0,
        ),
        pathImage: "assets/images/download.jpg",
        colorBegin: Colors.teal[600],
        colorEnd: Colors.teal[300],
        directionColorBegin: Alignment.topRight,
        directionColorEnd: Alignment.bottomLeft,
      ),
    );
  }

  void onDonePress() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('slider', true);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Home()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
      typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,
    );
  }
}
