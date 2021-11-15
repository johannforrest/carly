import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rive/rive.dart';
// import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          brightness: Brightness.light,
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          cardTheme: CardTheme(
              elevation: 7,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.ubuntuTextTheme(Theme.of(context).textTheme)),
      home: Scaffold(body: const Carly()),
    );
  }
}

class Carly extends StatefulWidget {
  const Carly({Key? key}) : super(key: key);

  @override
  State<Carly> createState() => _CarlyState();
}

final married = DateTime(2021, 11, 20, 4);
// AudioCache audioCache = AudioCache();
// AudioPlayer advancedPlayer = AudioPlayer();

class _CarlyState extends State<Carly> {
  late Timer clockTimer;
  late Timer slideShowTimer;
  late RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();
    clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
    currentProviderIndex = Random().nextInt(providers.length);
    slideShowTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        currentProviderIndex = (currentProviderIndex + 1) % providers.length;
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          trailingIndex = currentProviderIndex;
        });
      });
    });

    _controller = OneShotAnimation(
      'heart',
      mix: 2,
      autoplay: true,
    );
    // if (!kIsWeb && Platform.isIOS) {
    //   advancedPlayer.notificationService.startHeadlessService();
    // }

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      // advancedPlayer.setFilePath('assets/perfect.mp3');
      // final file = await audioCache.loadAsFile('perfect.mp3');
      // final bytes = await file.readAsBytes();
      // audioCache.playBytes(bytes, loop: true);
    });
  }

  int currentProviderIndex = 0;
  // used as a temporal trail behind currentprovider index that ensures photos swap after the animation
  int trailingIndex = 0;

  final List<Image> providers = [
    Image.asset(
      'assets/00100trPORTRAIT_00100_BURST20200704162345520_COVER.jpeg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/IMG_2124.jpeg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/IMG_2129.jpeg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/IMG_2469.jpeg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/IMG_20191116_174325.jpeg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/PXL_20201101_000416745.jpeg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/PXL_20201101_000424880.jpeg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/PXL_20211030_014242146.MP.jpg',
      fit: BoxFit.cover,
    ),
  ];
  final randomPoemIdx = Random().nextInt(poems.length);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().add(Duration(days: 0));
    final diff = married.difference(now).abs();
    final years = (diff.inDays / 365).floor();
    final days = diff.inDays % 365;
    final hours = diff.inHours % 24;
    final mins = diff.inMinutes % 60;
    String builder = '';
    if (years > 0) {
      builder += '${years.abs()}y ';
    }
    builder += '${days.abs()}d ';
    if (hours > 0) {
      builder += '${hours.abs()}h ';
    }

    if (mins > 0) {
      builder += '${mins.abs()}m ';
    }

    final inDays = NumberFormat().format(diff.inDays);
    final inHours = NumberFormat().format(diff.inHours);
    final inMonths = NumberFormat().format((diff.inDays / 30).floor());
    final inSeconds = NumberFormat().format(diff.inSeconds);
    final inMinutes = NumberFormat().format(diff.inMinutes);
    final randomPoem = poems[randomPoemIdx];

    return Stack(
      children: [
        Positioned.fill(
          child: ImageSlideshow(
              width: double.infinity,
              height: 200,
              initialPage: 0,
              indicatorColor: Colors.blue,
              indicatorBackgroundColor: Colors.grey,
              onPageChanged: (value) {
                debugPrint('Page changed: $value');
              },
              autoPlayInterval: 10000,
              isLoop: true,
              children: providers),
        ),
        Positioned.fill(
            child: RiveAnimation.asset(
          'assets/new_file.riv',
          artboard: 'New Artboard',
          controllers: [_controller],
        )),
        Positioned.fill(
          child: SingleChildScrollView(
            child: Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Card(
                    color: Theme.of(context).cardColor.withOpacity(0.5),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          Text(randomPoem,
                              style: GoogleFonts.mali(fontSize: 17)),
                          Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Column(
                              children: [
                                Text("Married for",
                                    style:
                                        GoogleFonts.parisienne(fontSize: 46)),
                                Text(builder.trim(),
                                    style:
                                        Theme.of(context).textTheme.headline3),
                                Text('$inMonths months',
                                    style:
                                        Theme.of(context).textTheme.headline4),
                                Text('$inDays days',
                                    style:
                                        Theme.of(context).textTheme.headline5),
                                Text('$inHours hours',
                                    style:
                                        Theme.of(context).textTheme.bodyText2),
                                Text('$inMinutes minutes',
                                    style:
                                        Theme.of(context).textTheme.bodyText2),
                                Text('$inSeconds seconds',
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(
                  height: 30,
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            )),
          ),
        ),
      ],
    );
  }
}

const poems = [
  "How do I love thee? Let me count the ways.\nI love thee to the depth and breadth and height\nMy soul can reach, when feeling out of sight\nFor the ends of being and ideal grace.\nI love thee to the level of every day's\nMost quiet need, by sun and candle-light.\nI love thee freely, as men strive for right.\nI love thee purely, as they turn from praise.\nI love thee with the passion put to use\nIn my old griefs, and with my childhood's faith.\nI love thee with a love I seemed to lose\nWith my lost saints. I love thee with the breath,\nSmiles, tears, of all my life; and, if God choose,\nI shall but love thee better after death.",
  'Looking up at the stars, I know quite well\nThat, for all they care, I can go to hell,\nBut on earth indifference is the least\nWe have to dread from man or beast.\n\nHow should we like it were stars to burn\nWith a passion for us we could not return?\nIf equal affection cannot be,\nLet the more loving one be me.\n\nAdmirer as I think I am\nOf stars that do not give a damn,\nI cannot, now I see them, say\nI missed one terribly all day.\n\nWere all stars to disappear or die,\nI should learn to look at an empty sky\nAnd feel its total dark sublime,\nThough this might take me a little time.',
  'You are a ukulele beyond my microphone\nYou are a Yukon beyond my Micronesia\nYou are a union beyond my meiosis\nYou are a unicycle beyond my migration\nYou are a universe beyond my mitochondria\nYou are a Eucharist beyond my Miles Davis\nYou are a euphony beyond my myocardiogram\nYou are a unicorn beyond my Minotaur\nYou are a eureka beyond my maitai\nYou are a Yuletide beyond my minesweeper\nYou are a euphemism beyond my myna bird',
  "Shall I compare thee to a summer’s day?\nThou art more lovely and more temperate.\nRough winds do shake the darling buds of May,\nAnd summer’s lease hath all too short a date.\nSometime too hot the eye of heaven shines,\nAnd often is his gold complexion dimmed;\nAnd every fair from fair sometime declines,\nBy chance, or nature’s changing course, untrimmed;\nBut thy eternal summer shall not fade,\nNor lose possession of that fair thou ow’st,\nNor shall death brag thou wand'rest in his shade,\nWhen in eternal lines to Time thou grow'st.\n    So long as men can breathe, or eyes can see,\n    So long lives this, and this gives life to thee.",
  "There is a kind of love called maintenance\nWhich stores the WD40 and knows when to use it\n\nWhich checks the insurance, and doesnt forget\n\nThe milkman; which remembers to plant bulbs;\nWhich answers letters; which knows the way\nThe money goes; which deals with dentists\n\nAnd Road Fund Tax and meeting trains,\nAnd postcards to the lonely; which upholds\n\nThe permanently rickety elaborate\nStructures of living, which is Atlas.\n\nAnd maintenance is the sensible side of love,\nWhich knows what time and weather are doing\nTo my brickwork; insulates my faulty wiring;\nLaughs at my dryrotten jokes; remembers\nMy need for gloss and grouting; which keeps\nMy suspect edifice upright in air,\nAs Atlas did the sky.",
  "When, in disgrace with fortune and men’s eyes,\nI all alone beweep my outcast state,\nAnd trouble deaf heaven with my bootless cries,\nAnd look upon myself and curse my fate,\nWishing me like to one more rich in hope,\nFeatured like him, like him with friends possessed,\nDesiring this man’s art and that man’s scope\nWith what I most enjoy contented least;\nYet in these thoughts myself almost despising,\nHaply I think on thee, and then my state,\n(Like to the lark at break of day arising\nFrom sullen earth) sings hymns at heaven’s gate;\nFor thy sweet love remembered such wealth brings\nThat then I scorn to change my state with kings.",
  "What sound was that?\n\nI turn away, into the shaking room.\n\nWhat was that sound that came in on the dark?\nWhat is this maze of light it leaves us in?\nWhat is this stance we take,\nTo turn away and then turn back?\nWhat did we hear?\n\nIt was the breath we took when we first met.\n\nListen. It is here.",
  "I think I was searching for treasures or stones\nin the clearest of pools\nwhen your face…\n\nwhen your face,\nlike the moon in a well\nwhere I might wish…\n\nmight well wish\nfor the iced fire of your kiss;\nonly on water my lips, where your face…\n\nwhere your face was reflected, lovely,\nnot really there when I turned\nto look behind at the emptying air…\n\nthe emptying air.",
  "It’s all I have to bring today—\nThis, and my heart beside—\nThis, and my heart, and all the fields—\nAnd all the meadows wide—\nBe sure you count—should I forget\nSome one the sum could tell—\nThis, and my heart, and all the Bees\nWhich in the Clover dwell."
];
