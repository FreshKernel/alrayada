import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:image_picker/image_picker.dart' show ImagePicker, ImageSource;
import 'package:mime/mime.dart';

import '../utils/extensions/xfile_ext.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({
    required this.onImagePicked,
    required this.initialImageProvider,
    super.key,
  });

  final void Function(XFile imageFile) onImagePicked;
  final ImageProvider? initialImageProvider;

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  XFile? _imageFile;

  DecorationImage? get _imageDecoration {
    final imageFile = _imageFile;
    if (imageFile != null) {
      return DecorationImage(
        image: imageFile.toImageProvider(),
        fit: BoxFit.cover,
      );
    }
    final initialImageProvider = widget.initialImageProvider;
    if (initialImageProvider != null) {
      return DecorationImage(
        image: initialImageProvider,
        fit: BoxFit.cover,
      );
    }
    return null;
  }

  void _onPickImage(XFile imageFile) {
    setState(() => _imageFile = imageFile);
    widget.onImagePicked(imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (details) {
        final file = details.files.firstOrNull;
        if (file == null) return;
        // TODO: Test the drag and drop in desktop
        final mimeType = lookupMimeType(file.path);
        final isImage = mimeType?.startsWith('image') ?? false;
        if (isImage) {
          return;
        }
        _onPickImage(file);
      },
      child: InkWell(
        onTap: () async {
          final imageFile =
              await ImagePicker().pickImage(source: ImageSource.gallery);
          if (imageFile == null) {
            return;
          }
          _onPickImage(imageFile);
        },
        onLongPress: () async {
          final imageFile =
              await ImagePicker().pickImage(source: ImageSource.camera);
          if (imageFile == null) {
            return;
          }
          _onPickImage(imageFile);
        },
        borderRadius: BorderRadius.circular(40.0),
        child: Ink(
          width: 125,
          height: 125,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(40.0),
            image: _imageDecoration,
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              style: BorderStyle.solid,
            ),
          ),
          child: widget.initialImageProvider == null && _imageFile == null
              ? Icon(
                  context.platformIcons.add,
                  size: 40,
                )
              : null,
        ),
      ),
    );
  }
}
