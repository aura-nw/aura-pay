// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:audioplayers/audioplayers.dart';
//
// enum PlayAudioType {
//   normal,
//   turtle,
// }
//
// class QuizAudio extends StatefulWidget {
//   final String source;
//   final String thumbnailUrl;
//
//   const QuizAudio({required this.source, required this.thumbnailUrl, Key? key})
//       : super(key: key);
//
//   @override
//   QuizAudioState createState() => QuizAudioState();
// }
//
// class QuizAudioState extends State<QuizAudio> with WidgetsBindingObserver {
//   late AudioPlayer player;
//   late String source;
//   late String thumbnailUrl;
//   bool _showControl = false;
//   final StreamController<PlayAudioType> _streamPlaying =
//   StreamController.broadcast();
//
//   Stream<PlayAudioType> get streamPlaying => _streamPlaying.stream;
//
//   Sink<PlayAudioType> get _sinkPlaying => _streamPlaying.sink;
//
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addObserver(this);
//
//     init();
//
//     player = AudioPlayer()
//       ..setUrl(source)
//       ..playerStateStream.listen(_listenPlayer);
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     switch (state) {
//       case AppLifecycleState.paused:
//         if (player.playing) {
//           player.pause();
//         }
//         break;
//       case AppLifecycleState.resumed:
//         if (!player.playing) {
//           player.play();
//         }
//         break;
//       case AppLifecycleState.inactive:
//       case AppLifecycleState.detached:
//     }
//   }
//
//   void _listenPlayer(PlayerState event) async {
//     switch (event.processingState) {
//       case ProcessingState.idle:
//         break;
//       case ProcessingState.loading:
//         break;
//       case ProcessingState.buffering:
//       case ProcessingState.ready:
//         await player.play();
//         break;
//       case ProcessingState.completed:
//         setState(() {
//           _showControl = true;
//         });
//     }
//   }
//
//   Future<void> startPlayer() async {
//     await player.seek(
//       const Duration(seconds: 0),
//     );
//
//     await player.setSpeed(1);
//
//     await player.play();
//
//     _sinkPlaying.add(PlayAudioType.normal);
//     setState(() {
//       _showControl = false;
//     });
//   }
//
//   Future<void> setSpeedPlayer() async {
//     setState(() {
//       _showControl = false;
//     });
//     await player.seek(
//       const Duration(seconds: 0),
//     );
//
//     _sinkPlaying.add(PlayAudioType.turtle);
//
//     await player.setSpeed(0.5);
//
//     await player.play();
//   }
//
//   void init() {
//     source =
//         ReplaceDomainHelper.replaceNewDoMain(widget.source) ?? widget.source;
//     thumbnailUrl = ReplaceDomainHelper.replaceNewDoMain(widget.thumbnailUrl) ??
//         widget.thumbnailUrl;
//   }
//
//   @override
//   void didUpdateWidget(covariant QuizAudio oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     init();
//   }
//
//   @override
//   void dispose() {
//     Future.microtask(
//           () async => await player.dispose(),
//     );
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (context.isTablet) {
//       return AspectRatio(
//         aspectRatio: 1.5,
//         child: Container(
//           clipBehavior: Clip.antiAlias,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: AppColors.lightSoftGrey,
//           ),
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               Image.network(thumbnailUrl, fit: BoxFit.cover),
//               _buildControl(),
//             ],
//           ),
//         ),
//       );
//     }
//     return AspectRatio(
//       aspectRatio: 1.32,
//       child: Container(
//         clipBehavior: Clip.antiAlias,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           color: AppColors.lightSoftGrey,
//         ),
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             CacheNetworkImageExtends(
//               imageUrl: thumbnailUrl,
//               targetWidth: context.maxW,
//               targetHeight: context.maxW,
//               loadingBuilder: (context, url, onProcess) {
//                 return Shimmer.fromColors(
//                   baseColor: const Color(0xffE9E7F1),
//                   highlightColor: const Color(0xffF2F0F2),
//                   child: const SizedBox(),
//                 );
//               },
//               errorBuilder: (context, url, error) {
//                 return Shimmer.fromColors(
//                   baseColor: const Color(0xffE9E7F1),
//                   highlightColor: const Color(0xffF2F0F2),
//                   child: const SizedBox(),
//                 );
//               },
//             ),
//             _buildControl(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildControl() {
//     if (context.isTablet) {
//       return Visibility(
//         visible: _showControl,
//         child: Center(
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               GestureDetector(
//                 onTap: () => setSpeedPlayer(),
//                 child: CircleAvatar(
//                   radius: 24,
//                   backgroundColor: AppColors.white.withOpacity(0.8),
//                   child: const Image(
//                     image: AppImages.turtle,
//                     height: 24,
//                     width: 24,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 30),
//               GestureDetector(
//                 onTap: () => startPlayer(),
//                 child: CircleAvatar(
//                   radius: 24,
//                   backgroundColor: AppColors.white.withOpacity(0.8),
//                   child: const Image(
//                     image: AppImages.play,
//                     height: 24,
//                     width: 24,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//     return Visibility(
//       visible: _showControl,
//       child: Center(
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             GestureDetector(
//               onTap: () => setSpeedPlayer(),
//               child: CircleAvatar(
//                 radius: 20,
//                 backgroundColor: AppColors.white.withOpacity(0.8),
//                 child: const Image(image: AppImages.turtle),
//               ),
//             ),
//             const SizedBox(width: 30),
//             GestureDetector(
//               onTap: () => startPlayer(),
//               child: CircleAvatar(
//                 radius: 20,
//                 backgroundColor: AppColors.white.withOpacity(0.8),
//                 child: const Image(image: AppImages.play),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
