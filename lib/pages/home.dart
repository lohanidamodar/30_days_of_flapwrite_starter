import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flappwrite_water_tracker/data/model/water_intake.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator_ns/liquid_progress_indicator.dart';

import 'history.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CarouselController _controller;
  int _page = 0;
  final int goal = 2500;
  int todaysIntake = 0;
  List<WaterIntake> intakes = [];

  @override
  void initState() {
    super.initState();
    _controller = CarouselController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlAppwrite Water Tracker'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              //Logout
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ListTile(
              title: Text(
                DateFormat.yMMMEd().format(DateTime.now()),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                icon: Icon(Icons.history),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HistoryPage(),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: LiquidCircularProgressIndicator(
                    direction: Axis.vertical,
                    borderWidth: 1,
                    borderColor: Colors.blue,
                    value: todaysIntake / goal,
                    center: Text(
                      "$todaysIntake / $goal ml",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    _controller.jumpToPage(--_page);
                  },
                  icon: Icon(Icons.keyboard_arrow_left),
                ),
                Expanded(
                  child: CarouselSlider(
                    carouselController: _controller,
                    options: CarouselOptions(
                        height: 70,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: false,
                        enlargeCenterPage: false,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (page, _) {
                          setState(() {
                            _page = page;
                          });
                        }),
                    items: [
                      WaterIntakeButton(
                        label: "100 ml",
                        onPressed: () => _waterIntake(100),
                      ),
                      WaterIntakeButton(
                        label: "200 ml",
                        onPressed: () => _waterIntake(200),
                      ),
                      WaterIntakeButton(
                        label: "300 ml",
                        onPressed: () => _waterIntake(300),
                      ),
                      WaterIntakeButton(
                        label: "400 ml",
                        onPressed: () => _waterIntake(400),
                      ),
                      WaterIntakeButton(
                        label: "500 ml",
                        onPressed: () => _waterIntake(500),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _controller.jumpToPage(++_page);
                  },
                  icon: Icon(Icons.keyboard_arrow_right),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _waterIntake(int amount) async {
    setState(() {
      todaysIntake += amount;
    });
  }
}

class WaterIntakeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final void Function()? onPressed;

  const WaterIntakeButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.icon = FontAwesomeIcons.coffee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        label: Text(label),
        icon: Icon(icon),
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }
}
