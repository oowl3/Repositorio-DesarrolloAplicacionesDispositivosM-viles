import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'position_data.dart';
import 'seek_bar.dart';
import 'rainbow_visualizer.dart'; // Importamos tu nuevo componente independiente

class AudioMetadata {
  final String artist;
  final String title;
  final String imagePath;
  AudioMetadata({required this.artist, required this.title, required this.imagePath});
}

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});
  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _cargarPlaylistAutomatica();
  }

  Future<void> _cargarPlaylistAutomatica() async {
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final rutasDeAudio = manifest.listAssets()
          .where((String key) => key.startsWith('assets/audio/') && key.toLowerCase().endsWith('.mp3'))
          .toList();

      if (rutasDeAudio.isEmpty) return;

      final fuentesDeAudio = rutasDeAudio.map((ruta) {
        final nombreArchivo = ruta.split('/').last.split('.').first;
        final partes = nombreArchivo.split('-');
        final artista = partes.length > 1 ? partes[0] : 'Desconocido';
        final tituloFormateado = (partes.length > 1 ? partes[1] : nombreArchivo)
            .replaceAll(RegExp(r'(?<=[a-z])(?=[A-Z])'), ' ');

        return AudioSource.asset(
          ruta, 
          tag: AudioMetadata(artist: artista, title: tituloFormateado, imagePath: 'assets/images/$nombreArchivo.jpg'),
        );
      }).toList();

      // ignore: deprecated_member_use
      await _audioPlayer.setAudioSource(ConcatenatingAudioSource(children: fuentesDeAudio));
    } catch (e) {
      debugPrint("🚨 ERROR: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream, _audioPlayer.bufferedPositionStream, _audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder<PlayerState>(
            stream: _audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final playing = snapshot.data?.playing ?? false;
           
              return RainbowVisualizer(isPlaying: playing);
            },
          ),


          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  
                  StreamBuilder<SequenceState?>(
                    stream: _audioPlayer.sequenceStateStream,
                    builder: (context, snapshot) {
                      final source = snapshot.data?.currentSource;
                      if (source == null || source.tag == null) return const SizedBox(height: 400);
                      return PlayerArtwork(metadata: source.tag as AudioMetadata);
                    },
                  ),
                  const SizedBox(height: 40),
                  
                  StreamBuilder<PositionData>(
                    stream: _positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      return SeekBar(
                        duration: positionData?.duration ?? Duration.zero,
                        position: positionData?.position ?? Duration.zero,
                        bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
                        onChangeEnd: _audioPlayer.seek,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  PlayerControls(audioPlayer: _audioPlayer),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Componentes Presentacionales (Sin cambios arquitectónicos)
class PlayerArtwork extends StatelessWidget {
  final AudioMetadata metadata;
  const PlayerArtwork({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 40, offset: const Offset(0, 15))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              metadata.imagePath, height: 300, width: 300, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(height: 300, width: 300, color: Colors.black),
            ),
          ),
        ),
        const SizedBox(height: 40),
        Text(metadata.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 8),
        Text(metadata.artist, style: TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

class PlayerControls extends StatelessWidget {
  final AudioPlayer audioPlayer;
  const PlayerControls({super.key, required this.audioPlayer});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(iconSize: 40, color: Colors.white70, icon: const Icon(Icons.skip_previous_rounded), onPressed: audioPlayer.seekToPrevious),
        StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playing = snapshot.data?.playing ?? false;
            final completed = snapshot.data?.processingState == ProcessingState.completed;
            
            Widget playPauseButton = IconButton(
              iconSize: 85, color: Colors.white,
              icon: Icon(completed ? Icons.replay_circle_filled_rounded : (playing ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded)),
              onPressed: completed ? () => audioPlayer.seek(Duration.zero, index: 0) : (playing ? audioPlayer.pause : audioPlayer.play),
            );

            return Container(
              decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 20, spreadRadius: 5)]),
              child: playPauseButton,
            );
          },
        ),
        IconButton(iconSize: 40, color: Colors.white70, icon: const Icon(Icons.skip_next_rounded), onPressed: audioPlayer.seekToNext),
      ],
    );
  }
}