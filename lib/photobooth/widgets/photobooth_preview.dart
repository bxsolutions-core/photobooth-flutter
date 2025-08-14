import 'package:analytics/analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/assets.g.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

const _initialCharacterScale = 0.25;
const _minCharacterScale = 0.1;

class PhotoboothPreview extends StatelessWidget {
  const PhotoboothPreview({
    required this.preview,
    required this.onSnapPressed,
    required this.aspectRatio,
    super.key,
  });

  final Widget preview;
  final VoidCallback onSnapPressed;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsetsGeometry.fromLTRB(20, 0, 20, 0),
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: ColoredBox(
                color: PhotoboothColors.peridotGreen,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: PhotoboothColors.peridotGreen,
                      borderRadius: BorderRadius.circular(12), // same radius
                      // If you set only borderRadius here, it's fine if Container has a color
                    ),
                    child: preview,
                  ),
                ),
              ),
            ),
          ),
        ),

        Positioned.fill(
          child: GestureDetector(
            key: const Key('photoboothPreview_background_gestureDetector'),
            onTap: () {
              context.read<PhotoboothBloc>().add(const PhotoTapped());
            },
          ),
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ShutterButton(
              key: const Key('photoboothPreview_photo_shutterButton'),
              onCountdownComplete: onSnapPressed,
            ),
          ),
        ),
      ],
    );
  }
}

BoxConstraints? _getAnimatedSpriteConstraints(String name) {
  final sprite = _getAnimatedSprite(name);

  if (sprite == null) return null;

  final size = sprite.sprites.size;
  return BoxConstraints(
    minWidth: size.width * _minCharacterScale,
    minHeight: size.height * _minCharacterScale,
  );
}

Size _getAnimatedSpriteSize(String name) {
  final sprite = _getAnimatedSprite(name);
  if (sprite != null) return sprite.sprites.size * _initialCharacterScale;
  return Size.zero;
}

AnimatedSprite? _getAnimatedSprite(String name) {
  switch (name) {
    case 'android':
      return const AnimatedAndroid();
    case 'dash':
      return const AnimatedDash();
    case 'dino':
      return const AnimatedDino();
    case 'sparky':
      return const AnimatedSparky();
    default:
      return null;
  }
}

class _AnimatedCharacter extends StatelessWidget {
  const _AnimatedCharacter({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return _getAnimatedSprite(name) ?? const SizedBox();
  }
}

class CharactersIconLayout extends StatelessWidget {
  const CharactersIconLayout({
    required this.children,
    super.key,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.landscape
        ? LandscapeCharactersIconLayout(children: children)
        : PortraitCharactersIconLayout(children: children);
  }
}

@visibleForTesting
class LandscapeCharactersIconLayout extends StatelessWidget {
  const LandscapeCharactersIconLayout({
    required this.children,
    super.key,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CharactersCaption(),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: children,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

@visibleForTesting
class PortraitCharactersIconLayout extends StatelessWidget {
  const PortraitCharactersIconLayout({
    required this.children,
    super.key,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: children,
              ),
            ),
          ),
          BlocBuilder<PhotoboothBloc, PhotoboothState>(
            builder: (context, state) {
              if (state.isAnyCharacterSelected) return const SizedBox();
              return const CharactersCaption();
            },
          ),
        ],
      ),
    );
  }
}
