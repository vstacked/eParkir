import 'package:eparkir/main.dart';
import 'package:eparkir/utils/textStyle.dart';
import 'package:flutter/material.dart';
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
          color: Colors.teal,
        ),
        backgroundColor: Colors.white,
        maxLineTitle: 2,
        pathImage: "assets/images/logo2.png",
      ),
    );
    slides.add(
      new Slide(
        title: 'Pengertian',
        styleTitle: style.title.copyWith(
          fontSize: 30.0,
          color: Colors.teal,
        ),
        description:
            'eParkir adalah aplikasi scanner pengganti "karcis / tiket" saat masuk ke sekolah, menjadi lebih fleksibel dan efisien.',
        styleDescription: style.desc.copyWith(
          color: Colors.teal,
          fontSize: 15.0,
        ),
        pathImage: "assets/images/logo2.png",
        backgroundColor: Colors.white,
      ),
    );
    slides.add(
      new Slide(
        title: 'Manfaat',
        styleTitle: style.title.copyWith(
          fontSize: 30.0,
          color: Colors.teal,
        ),
        description:
            'Bagi murid, cara ini lebih efisien. Karena tidak ada ketakutan karcis / tiket itu hilang. Dan juga, aplikasi ini dijalankan di smartphone yang di jaman sekarang ini kebanyakan siswa telah memilikinya.\n\n Bagi petugas, cara ini bisa lebih cepat. Karena tidak perlu membawa karcis / tiket, dan mengambilnya lagi ketika sudah habis. Cukup dengan smartphone, bisa langsung menggunakan scan tanpa perlu repot-repot lagi. \n\n Jadi tunggu apalagi, ayo coba sekarang!!',
        styleDescription: style.desc.copyWith(
          color: Colors.teal,
          fontSize: 15.0,
        ),
        pathImage: "assets/images/download.jpg",
        backgroundColor: Colors.white,
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
      // typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,
      nameDoneBtn: 'Go',
      colorDoneBtn: Colors.teal,
      colorPrevBtn: Colors.teal,
      colorSkipBtn: Colors.teal,
      colorActiveDot: Colors.teal,
      colorDot: Colors.grey,
      sizeDot: 10.0,
      styleNameDoneBtn:
          style.desc.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      styleNamePrevBtn:
          style.desc.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      styleNameSkipBtn:
          style.desc.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
    );
  }
}
