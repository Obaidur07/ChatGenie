import 'package:animate_do/animate_do.dart';
import 'package:chatgenie/colors.dart';
import 'package:chatgenie/feature_box.dart';
import 'package:chatgenie/openai_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();
  String? generatedContent;
  String? generatedImageURL;
  int start = 200;
  int delay = 200;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(

          child: const Text('ChatGenie',style: TextStyle(
            fontFamily: 'Cera Pro',
          ),),
        ),
        leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //virtual assistant Picture
            ZoomIn(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 5),
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          color: AppColor.assistantCircleColor,
                          borderRadius: BorderRadius.circular(60)
                      ),
                    ),
                  ),
                  Container(
                    height: 123,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image: AssetImage(
                        'assets/images/virtualAssistant.png'
                      ))
                    ),
                  )
                ],
              ),
            ),
            //Chat Bubble
            FadeInRight(
              child: Visibility(
                visible: generatedImageURL==null,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(top: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 7
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black,width: 0.5),
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      generatedContent == null ? 'Good Morning, What can I do for you?':generatedContent!,
                      style: TextStyle(
                      fontFamily: 'Cera Pro',
                      color: AppColor.mainFontColor,
                      fontSize: generatedContent == null ? 23:15
                    ),),
                  ),
                ),
              ),
            ),
            if(generatedImageURL != null)
            Padding(
              padding: const EdgeInsets.all(15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                    child: Image.network(generatedImageURL!))),
            Visibility(
              visible: generatedContent==null&&generatedImageURL==null,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(
                  top: 5,
                  left: 22,
                ),
                child: const Text(
                    'Here are few features!!',
                  style: TextStyle(
                    fontFamily: 'Cera Pro',
                    color: AppColor.mainFontColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            //Feature List
            Visibility(
              visible: generatedContent==null&&generatedImageURL==null,
              child: const Column(
                children: [
                  FeatureBox(
                    color: AppColor.firstSuggestionBoxColor,
                    headerText: 'ChatGPT',
                    descriptionText: 'A smarter way to stay organized and informed with ChatGPT',),
                  FeatureBox(
                    color: AppColor.secondSuggestionBoxColor,
                    headerText: 'Dall-E',
                    descriptionText: 'Get inspired and stay creative with your personal assistant powered by Dall-E',),
                  FeatureBox(
                    color: AppColor.thirdSuggestionBoxColor,
                    headerText: 'Smart Voice Assistant',
                    descriptionText: 'Get the best of both worlds with a voice assistant powered by ChatGPT and Dall-E',),
                ],
              ),
            ),
          ],
        ),
      ),
    floatingActionButton: ZoomIn(
    delay: Duration(milliseconds: start + 3 * delay),
    child: FloatingActionButton(
    backgroundColor: AppColor.secondSuggestionBoxColor,
    onPressed: () async {
    if (await speechToText.hasPermission &&
    speechToText.isNotListening) {
    await startListening();
    } else if (speechToText.isListening) {
    final speech = await openAIService.isArtPromptAPI(lastWords);
    if (speech.contains('https')) {
    generatedImageURL = speech;
    generatedContent = null;
    setState(() {});
    } else {
    generatedImageURL = null;
    generatedContent = speech;
    setState(() {});
    await systemSpeak(speech);
    }
    await stopListening();
    } else {
    initSpeechToText();
    }
    },
    child: Icon(
    speechToText.isListening ? Icons.stop : Icons.mic,
    ),
    ),
    ),
    );
  }
}
