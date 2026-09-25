import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'models/booth_layout.dart';
import 'models/photo_session.dart';
import 'services/app_settings.dart';
import 'services/device_actions.dart';
import 'services/photo_composer.dart';
import 'services/session_store.dart';

const purple = Color(0xFF5B21F5);
const pink = Color(0xFFE52C91);
const ink = Color(0xFF20232B);
const canvas = Color(0xFFF8F5FF);
const brandGradient = LinearGradient(
  colors: [purple, Color(0xFF7C2BE8), pink],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(PhotoSessionAdapter());
  final box = await Hive.openBox<PhotoSession>('photo_sessions');
  final settingsBox = await Hive.openBox<bool>('app_settings');
  runApp(
    PhotoBoothApp(store: SessionStore(box), settings: AppSettings(settingsBox)),
  );
}

class PhotoBoothApp extends StatelessWidget {
  const PhotoBoothApp({super.key, required this.store, required this.settings});
  final SessionStore store;
  final AppSettings settings;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Photo Booth Maker',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: canvas,
      colorScheme: ColorScheme.fromSeed(seedColor: purple),
    ),
    home: HomeScreen(store: store, settings: settings),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.store, required this.settings});
  final SessionStore store;
  final AppSettings settings;

  Future<void> _start(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LayoutSelectionScreen(store: store, settings: settings),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ValueListenableBuilder(
        valueListenable: store.listenable(),
        builder: (context, _, _) {
          final sessions = store.sessions;
          return ListView(
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 32),
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SettingsScreen(settings: settings),
                        ),
                      ),
                      icon: const Icon(Icons.settings_outlined),
                      tooltip: 'Settings',
                    ),
                    IconButton(
                      onPressed: () => showAboutDialog(
                        context: context,
                        applicationName: 'Photo Booth Maker',
                        applicationVersion: 'MVP',
                      ),
                      icon: const Icon(Icons.info_outline_rounded),
                      tooltip: 'About',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(31),
                  child: Image.asset(
                    'lib/logo/photoboot-logo.png',
                    width: 128,
                    height: 128,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Photo Booth\nMaker',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 34,
                  height: 1.04,
                  fontWeight: FontWeight.w900,
                  color: ink,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Pick a frame, pose, and make a memory ✨',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Color(0xFF686375)),
              ),
              const SizedBox(height: 34),
              BrandButton(
                label: 'TAKE PHOTOS',
                icon: Icons.camera_alt_rounded,
                onTap: () => _start(context),
              ),
              const SizedBox(height: 38),
              Row(
                children: [
                  const Text(
                    'Recent',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: ink,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: sessions.isEmpty
                        ? null
                        : () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => GalleryScreen(store: store),
                            ),
                          ),
                    child: const Text('See all'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (sessions.isEmpty)
                const EmptyRecent()
              else
                RecentGrid(sessions: sessions.take(3).toList()),
            ],
          );
        },
      ),
    ),
  );
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.settings});
  final AppSettings settings;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          const PageHeader(title: 'Settings'),
          AnimatedBuilder(
            animation: settings,
            builder: (_, _) => SwitchListTile.adaptive(
              contentPadding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
              title: const Text(
                'Mirror camera',
                style: TextStyle(fontWeight: FontWeight.w800, color: ink),
              ),
              subtitle: const Text(
                'Flip the preview and saved photos horizontally.',
                style: TextStyle(color: Color(0xFF686375)),
              ),
              value: settings.mirrorCamera,
              onChanged: settings.setMirrorCamera,
            ),
          ),
        ],
      ),
    ),
  );
}

class LayoutSelectionScreen extends StatefulWidget {
  const LayoutSelectionScreen({
    super.key,
    required this.store,
    required this.settings,
  });
  final SessionStore store;
  final AppSettings settings;

  @override
  State<LayoutSelectionScreen> createState() => _LayoutSelectionScreenState();
}

class _LayoutSelectionScreenState extends State<LayoutSelectionScreen> {
  PhotoBoothLayout selected = photoBoothLayouts.first;

  Future<void> _continue() async {
    final timer = await Navigator.of(context).push<int>(
      MaterialPageRoute(builder: (_) => TimerSelectionScreen(layout: selected)),
    );
    if (!mounted || timer == null) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CameraSessionScreen(
          layout: selected,
          timerSeconds: timer,
          store: widget.store,
          settings: widget.settings,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          const PageHeader(title: 'Choose a layout'),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pick your favorite frame ✨',
                style: TextStyle(color: Color(0xFF686375)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              itemCount: photoBoothLayouts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: .72,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, index) {
                final layout = photoBoothLayouts[index];
                return LayoutCard(
                  layout: layout,
                  selected: selected == layout,
                  onTap: () => setState(() => selected = layout),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: BrandButton(
              label: 'CONTINUE',
              icon: Icons.arrow_forward_rounded,
              onTap: _continue,
            ),
          ),
        ],
      ),
    ),
  );
}

class TimerSelectionScreen extends StatefulWidget {
  const TimerSelectionScreen({super.key, required this.layout});
  final PhotoBoothLayout layout;

  @override
  State<TimerSelectionScreen> createState() => _TimerSelectionScreenState();
}

class _TimerSelectionScreenState extends State<TimerSelectionScreen> {
  int selected = 3;
  static const options = [
    (0, 'Instant', Icons.bolt_rounded),
    (3, '3 seconds', Icons.looks_3_rounded),
    (5, '5 seconds', Icons.timer_outlined),
    (10, '10 seconds', Icons.timelapse_rounded),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          const PageHeader(title: 'Choose countdown'),
          Padding(
            padding: EdgeInsets.fromLTRB(24, 0, 24, 18),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'You need ${widget.layout.photoCount} photos for every pose.',
                style: TextStyle(color: Color(0xFF686375)),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: options.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                final option = options[index];
                final active = option.$1 == selected;
                return InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => setState(() => selected = option.$1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.all(17),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: active ? purple : const Color(0xFFE7E1F2),
                        width: active ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleIcon(icon: option.$3, active: active),
                        const SizedBox(width: 15),
                        Text(
                          option.$2,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: ink,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          active
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          color: active ? pink : const Color(0xFFC3BDCE),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: BrandButton(
              label: 'START ${widget.layout.photoCount}-PHOTO SESSION',
              icon: Icons.camera_alt_rounded,
              onTap: () => Navigator.of(context).pop(selected),
            ),
          ),
        ],
      ),
    ),
  );
}

class CameraSessionScreen extends StatefulWidget {
  const CameraSessionScreen({
    super.key,
    required this.layout,
    required this.timerSeconds,
    required this.store,
    required this.settings,
  });
  final PhotoBoothLayout layout;
  final int timerSeconds;
  final SessionStore store;
  final AppSettings settings;

  @override
  State<CameraSessionScreen> createState() => _CameraSessionScreenState();
}

class _CameraSessionScreenState extends State<CameraSessionScreen>
    with WidgetsBindingObserver {
  final _composer = PhotoComposer();
  CameraController? _controller;
  Future<void> _cameraDisposal = Future<void>.value();
  List<CameraDescription> _cameras = [];
  CameraDescription? _camera;
  final List<File> _captured = [];
  final List<bool> _capturedMirrored = [];
  bool _flashEnabled = false;
  bool _busy = false;
  bool _finished = false;
  String? _error;
  int? _countdown;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _prepareCamera();
  }

  Future<void> _prepareCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (mounted) {
        setState(
          () => _error = status.isPermanentlyDenied
              ? 'Camera access is off. Open Settings to allow it.'
              : 'Camera access is required to take photos.',
        );
      }
      return;
    }
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        throw StateError('No camera is available on this device.');
      }
      _camera ??= _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      );
      await _initializeController();
    } catch (error) {
      if (mounted) {
        setState(
          () => _error = 'Camera unavailable. ${_readableCameraError(error)}',
        );
      }
    }
  }

  Future<void> _initializeController() async {
    final prior = _controller;
    final controller = CameraController(
      _camera!,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _controller = controller;
    await _cameraDisposal;
    await prior?.dispose();
    await controller.initialize();
    if (!mounted || _controller != controller) return;
    await controller.setFlashMode(
      _flashEnabled ? FlashMode.always : FlashMode.off,
    );
    setState(() => _error = null);
  }

  String _readableCameraError(Object error) {
    if (error is CameraException && error.code == 'CameraAccessDenied') {
      return 'Please allow camera access and try again.';
    }
    return error.toString().replaceFirst('Exception: ', '');
  }

  Future<void> _takePhoto() async {
    if (_busy || _controller == null || !_controller!.value.isInitialized) {
      return;
    }
    setState(() => _busy = true);
    try {
      for (var seconds = widget.timerSeconds; seconds > 0; seconds--) {
        if (!mounted) return;
        setState(() => _countdown = seconds);
        await Future<void>.delayed(const Duration(seconds: 1));
      }
      if (!mounted) return;
      setState(() => _countdown = null);
      final photo = await _controller!.takePicture();
      _captured.add(File(photo.path));
      _capturedMirrored.add(widget.settings.mirrorCamera);
      if (_captured.length == widget.layout.photoCount) await _review();
    } on CameraException catch (error) {
      _showMessage(
        'Could not capture photo: ${error.description ?? error.code}',
      );
    } catch (error) {
      _showMessage('Could not capture photo: $error');
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _countdown = null;
        });
      }
    }
  }

  Future<void> _review() async {
    final usePhotos = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ReviewScreen(
          layout: widget.layout,
          photos: _captured,
          mirrorPhotos: _capturedMirrored,
        ),
      ),
    );
    if (!mounted) return;
    if (usePhotos == true) {
      await _composeAndShowResult();
    } else if (usePhotos == false) {
      for (final file in _captured) {
        if (await file.exists()) await file.delete();
      }
      setState(() {
        _captured.clear();
        _capturedMirrored.clear();
      });
    }
  }

  Future<void> _composeAndShowResult() async {
    setState(() => _busy = true);
    try {
      final output = await _composer.compose(
        layout: widget.layout,
        photos: _captured,
        mirrorPhotos: _capturedMirrored,
      );
      final session = PhotoSession(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
        layoutId: widget.layout.id,
        timerSeconds: widget.timerSeconds,
        outputPath: output.path,
      );
      await widget.store.add(session);
      for (final file in _captured) {
        if (await file.exists()) await file.delete();
      }
      _finished = true;
      if (!mounted) return;
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ResultScreen(session: session, store: widget.store),
        ),
      );
    } catch (error) {
      for (final photo in _captured) {
        if (await photo.exists()) await photo.delete();
      }
      _captured.clear();
      _capturedMirrored.clear();
      _showMessage('We could not create your photo: $error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2 || _busy) return;
    final next = _cameras.firstWhere(
      (camera) => camera != _camera,
      orElse: () => _camera!,
    );
    setState(() {
      _camera = next;
      _busy = true;
    });
    try {
      await _initializeController();
    } catch (error) {
      _showMessage('Could not switch camera: $error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _toggleFlash() async {
    if (_controller == null || _busy) return;
    try {
      final enabled = !_flashEnabled;
      await _controller!.setFlashMode(
        enabled ? FlashMode.always : FlashMode.off,
      );
      setState(() => _flashEnabled = enabled);
    } on CameraException {
      _showMessage('Flash is not available on this camera.');
    }
  }

  void _showMessage(String text) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      final controller = _controller;
      if (controller != null && controller.value.isInitialized) {
        _controller = null;
        _cameraDisposal = controller.dispose();
      }
    }
    if (state == AppLifecycleState.resumed &&
        _camera != null &&
        _controller == null) {
      _restoreCamera();
    }
  }

  Future<void> _restoreCamera() async {
    try {
      await _initializeController();
    } catch (error) {
      if (mounted) setState(() => _error = 'Camera unavailable. $error');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    if (!_finished) {
      for (final file in _captured) {
        file.delete().ignore();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF17131E),
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Row(
              children: [
                IconButton(
                  onPressed: _busy ? null : () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                  tooltip: 'Cancel session',
                ),
                const Spacer(),
                Text(
                  'PHOTO ${_captured.length + 1} OF ${widget.layout.photoCount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _toggleFlash,
                  icon: Icon(
                    _flashEnabled
                        ? Icons.flash_on_rounded
                        : Icons.flash_off_rounded,
                    color: Colors.white,
                  ),
                  tooltip: 'Flash',
                ),
                IconButton(
                  onPressed: _switchCamera,
                  icon: const Icon(
                    Icons.cameraswitch_outlined,
                    color: Colors.white,
                  ),
                  tooltip: 'Switch camera',
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _cameraBody(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.layout.photoCount,
                    (index) => Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index < _captured.length
                            ? pink
                            : index == _captured.length
                            ? Colors.white
                            : const Color(0xFF625A68),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                GestureDetector(
                  onTap: _takePhoto,
                  child: Container(
                    width: 78,
                    height: 78,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: brandGradient,
                      ),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.timerSeconds == 0
                      ? 'Tap to capture'
                      : '${widget.timerSeconds}-second countdown',
                  style: const TextStyle(
                    color: Color(0xBBFFFFFF),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _cameraBody() {
    if (_error != null) {
      return CameraError(
        message: _error!,
        openSettings: _error!.contains('Open Settings')
            ? openAppSettings
            : null,
      );
    }
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: widget.settings,
            builder: (_, child) => Transform(
              alignment: Alignment.center,
              transform: Matrix4.diagonal3Values(
                widget.settings.mirrorCamera ? -1 : 1,
                1,
                1,
              ),
              child: child,
            ),
            child: CameraPreview(controller),
          ),
          if (_countdown != null)
            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: Text(
                  '${_countdown!}',
                  key: ValueKey(_countdown),
                  style: const TextStyle(
                    fontSize: 118,
                    height: 1,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 12)],
                  ),
                ),
              ),
            ),
          if (_busy && _countdown == null)
            const ColoredBox(
              color: Color(0x44000000),
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({
    super.key,
    required this.layout,
    required this.photos,
    required this.mirrorPhotos,
  });
  final PhotoBoothLayout layout;
  final List<File> photos;
  final List<bool> mirrorPhotos;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 30),
        children: [
          const PageHeader(title: 'Looking good! ✨'),
          const Text(
            'Review your photos before creating the final frame.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF686375)),
          ),
          const SizedBox(height: 28),
          Center(
            child: PhotoFrame(
              layout: layout,
              photos: photos,
              mirrorPhotos: mirrorPhotos,
              large: true,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(false),
                  icon: const Icon(Icons.replay_rounded),
                  label: const Text('RETAKE'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    foregroundColor: purple,
                    side: const BorderSide(color: purple),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: BrandButton(
                  label: 'USE PHOTOS',
                  icon: Icons.check_rounded,
                  onTap: () => Navigator.of(context).pop(true),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, required this.session, required this.store});
  final PhotoSession session;
  final SessionStore store;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final _actions = DeviceActions();
  bool _working = false;

  File get file => File(widget.session.outputPath);

  Future<void> _run(Future<void> Function() action, String success) async {
    setState(() => _working = true);
    try {
      await action();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(success)));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('That did not work: $error')));
      }
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  void _home() => Navigator.of(context).popUntil((route) => route.isFirst);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
        children: [
          Row(
            children: [
              IconButton(onPressed: _home, icon: const Icon(Icons.close)),
              const Spacer(),
              const Text(
                'YOUR PHOTO',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: .8,
                ),
              ),
              const Spacer(),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Your photo is ready! ✨',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w900,
              color: ink,
            ),
          ),
          const SizedBox(height: 26),
          Center(
            child: PhotoFrame(
              layout: photoBoothLayouts.firstWhere(
                (layout) => layout.id == widget.session.layoutId,
              ),
              photos: [file],
              finalPhoto: true,
              large: true,
            ),
          ),
          const SizedBox(height: 28),
          BrandButton(
            label: _working ? 'PLEASE WAIT…' : 'SAVE TO PHOTOS',
            icon: Icons.download_rounded,
            onTap: _working
                ? () {}
                : () => _run(
                    () => _actions.saveToGallery(file),
                    '✨ Saved to your photos!',
                  ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ActionButton(
                  label: 'SHARE',
                  icon: Icons.ios_share_rounded,
                  onTap: _working
                      ? null
                      : () => _run(
                          () => _actions.share(file),
                          'Share sheet opened.',
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ActionButton(
                  label: 'PRINT',
                  icon: Icons.print_outlined,
                  onTap: _working
                      ? null
                      : () => _run(
                          () => _actions.printPhoto(file),
                          'Printer selection opened.',
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: _home,
            icon: const Icon(Icons.camera_alt_rounded),
            label: const Text('NEW PHOTO'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
              foregroundColor: purple,
              side: const BorderSide(color: purple),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key, required this.store});
  final SessionStore store;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ValueListenableBuilder(
        valueListenable: store.listenable(),
        builder: (context, _, _) {
          final sessions = store.sessions;
          return Column(
            children: [
              const PageHeader(title: 'My photos'),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Your recent moments, all in one place.',
                    style: TextStyle(color: Color(0xFF686375)),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: sessions.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemBuilder: (_, index) =>
                      GalleryTile(session: sessions[index], store: store),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

class PageHeader extends StatelessWidget {
  const PageHeader({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 8, 20, 18),
    child: Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Back',
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: ink,
          ),
        ),
      ],
    ),
  );
}

class BrandButton extends StatelessWidget {
  const BrandButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: brandGradient,
      borderRadius: BorderRadius.circular(17),
      boxShadow: const [
        BoxShadow(
          color: Color(0x405B21F5),
          blurRadius: 16,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: onTap,
        child: SizedBox(
          height: 58,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .4,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onTap,
    icon: Icon(icon),
    label: Text(label),
    style: OutlinedButton.styleFrom(
      minimumSize: const Size.fromHeight(56),
      foregroundColor: purple,
      side: const BorderSide(color: Color(0xFFE0D8F1)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}

class CircleIcon extends StatelessWidget {
  const CircleIcon({super.key, required this.icon, required this.active});
  final IconData icon;
  final bool active;
  @override
  Widget build(BuildContext context) => Container(
    width: 46,
    height: 46,
    decoration: BoxDecoration(
      gradient: active ? brandGradient : null,
      color: active ? null : const Color(0xFFF1EDFA),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Icon(icon, color: active ? Colors.white : purple),
  );
}

class LayoutCard extends StatelessWidget {
  const LayoutCard({
    super.key,
    required this.layout,
    required this.selected,
    required this.onTap,
  });
  final PhotoBoothLayout layout;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? purple : const Color(0xFFE7E1F2),
          width: selected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                LayoutPreview(layout: layout),
                if (selected)
                  const Positioned(
                    top: 0,
                    right: 0,
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: pink,
                      size: 18,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Layout ${layout.id}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: ink,
            ),
          ),
          Text(
            '${layout.photoCount} poses',
            style: const TextStyle(fontSize: 10, color: Color(0xFF777182)),
          ),
        ],
      ),
    ),
  );
}

class LayoutPreview extends StatelessWidget {
  const LayoutPreview({super.key, required this.layout});
  final PhotoBoothLayout layout;
  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: layout.aspectRatio,
    child: Container(
      decoration: BoxDecoration(
        color: Color(layout.colorValue),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: LayoutBuilder(
        builder: (_, constraints) => Stack(
          children: [
            for (final slot in layout.slots)
              Positioned(
                left: slot.x * constraints.maxWidth,
                top: slot.y * constraints.maxHeight,
                width: slot.width * constraints.maxWidth,
                height: slot.height * constraints.maxHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C2BE8),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

class PhotoFrame extends StatelessWidget {
  const PhotoFrame({
    super.key,
    required this.layout,
    required this.photos,
    this.mirrorPhotos = const [],
    this.finalPhoto = false,
    this.large = false,
  });
  final PhotoBoothLayout layout;
  final List<File> photos;
  final List<bool> mirrorPhotos;
  final bool finalPhoto;
  final bool large;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: large ? (layout.isStrip ? 210 : 330) : null,
    child: AspectRatio(
      aspectRatio: layout.aspectRatio,
      child: Container(
        padding: EdgeInsets.all(large ? 5 : 3),
        decoration: BoxDecoration(
          color: Color(layout.colorValue),
          borderRadius: BorderRadius.circular(large ? 18 : 8),
          border: Border.all(color: Colors.white, width: large ? 4 : 2),
          boxShadow: large
              ? const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 18,
                    offset: Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: finalPhoto
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(photos.first, fit: BoxFit.cover),
              )
            : LayoutBuilder(
                builder: (_, constraints) => Stack(
                  children: [
                    for (var index = 0; index < layout.slots.length; index++)
                      _slot(index, constraints),
                  ],
                ),
              ),
      ),
    ),
  );

  Widget _slot(int index, BoxConstraints constraints) {
    final slot = layout.slots[index];
    return Positioned(
      left: slot.x * constraints.maxWidth,
      top: slot.y * constraints.maxHeight,
      width: slot.width * constraints.maxWidth,
      height: slot.height * constraints.maxHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(large ? 7 : 3),
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.diagonal3Values(
            index < mirrorPhotos.length && mirrorPhotos[index] ? -1 : 1,
            1,
            1,
          ),
          child: Image.file(photos[index], fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class EmptyRecent extends StatelessWidget {
  const EmptyRecent({super.key});
  @override
  Widget build(BuildContext context) => Container(
    height: 112,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFE9E3F4)),
    ),
    child: const Center(
      child: Text(
        'Your photo booth moments will appear here.',
        style: TextStyle(color: Color(0xFF777182)),
      ),
    ),
  );
}

class RecentGrid extends StatelessWidget {
  const RecentGrid({super.key, required this.sessions});
  final List<PhotoSession> sessions;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (var index = 0; index < sessions.length; index++)
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == sessions.length - 1 ? 0 : 12,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AspectRatio(
                aspectRatio: .72,
                child: Image.file(
                  File(sessions[index].outputPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
    ],
  );
}

class GalleryTile extends StatelessWidget {
  const GalleryTile({super.key, required this.session, required this.store});
  final PhotoSession session;
  final SessionStore store;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ResultScreen(session: session, store: store),
      ),
    ),
    child: Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.file(
            File(session.outputPath),
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                const ColoredBox(color: Color(0xFFE8E1F4)),
          ),
        ),
        Positioned(
          right: 4,
          top: 4,
          child: IconButton(
            onPressed: () => store.delete(session),
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.white),
            tooltip: 'Delete photo',
          ),
        ),
      ],
    ),
  );
}

class CameraError extends StatelessWidget {
  const CameraError({
    super.key,
    required this.message,
    required this.openSettings,
  });
  final String message;
  final Future<void> Function()? openSettings;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.no_photography_outlined,
            color: Colors.white,
            size: 54,
          ),
          const SizedBox(height: 18),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          if (openSettings != null) ...[
            const SizedBox(height: 18),
            OutlinedButton(
              onPressed: openSettings,
              style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
              child: const Text('OPEN SETTINGS'),
            ),
          ],
        ],
      ),
    ),
  );
}
