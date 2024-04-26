import 'package:cached_network_image/cached_network_image.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../../../data/product/category/product_category.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../utils/validators/global_validator.dart';
import '../../../../../widgets/image_picker_widget.dart';

@immutable
class AdminAddEditCategoryDialogData {
  const AdminAddEditCategoryDialogData({
    required this.name,
    required this.description,
    required this.imageFile,
  });

  final String name;
  final String description;
  final XFile? imageFile;

  /// Will be used for creating category
  XFile get imageFileOrThrow =>
      imageFile ?? (throw StateError('The image file is required'));
}

class AdminAddEditCategoryDialog extends StatefulWidget {
  const AdminAddEditCategoryDialog({
    required this.initialCategory,
    required this.onSubmit,
    super.key,
  });

  /// If you want to add a new category, pass null to [initialCategory]
  /// otherwise pass the existing category so use it default values
  final ProductCategory? initialCategory;

  /// The widget will call [Navigator.pop] before call [onSubmit]
  /// if [initialCategory] is not null then the image file can be nullable
  /// otherwise it should not be null
  final void Function(AdminAddEditCategoryDialogData data) onSubmit;

  static void show({
    required BuildContext context,
    required ProductCategory? initialCategory,
    required void Function(AdminAddEditCategoryDialogData data) onSubmit,
  }) =>
      showDialog(
        context: context,
        builder: (context) => AdminAddEditCategoryDialog(
          initialCategory: initialCategory,
          onSubmit: onSubmit,
        ),
      );

  @override
  State<AdminAddEditCategoryDialog> createState() =>
      _AdminAddEditCategoryDialogState();
}

class _AdminAddEditCategoryDialogState
    extends State<AdminAddEditCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    final category = widget.initialCategory;
    if (category != null) {
      _nameController.text = category.name;
      _descriptionController.text = category.description;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// if the user is updating the category then uploading a new image is optional
  /// otherwise the user needs to upload a new image
  bool get _isValidData {
    final isTextInputsValid = _formKey.currentState?.validate() ?? false;
    if (widget.initialCategory != null) {
      // Uploading a new image is optional
      return isTextInputsValid;
    }
    return isTextInputsValid && _imageFile != null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.initialCategory != null
            ? '${context.loc.edit} ${widget.initialCategory?.name}'
            : context.loc.add,
      ),
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImagePickerWidget(
                onImagePicked: (imageFile) => _imageFile = imageFile,
                initialImageProvider: widget.initialCategory != null
                    ? CachedNetworkImageProvider(widget
                            .initialCategory?.imageUrls.first ??
                        (throw StateError('The category should not be null')))
                    : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                validator: (value) => GlobalValidator.validateTextIsEmpty(
                  value ?? '',
                  errorMessage: context.loc.thisFieldCantBeEmpty,
                ),
                decoration: InputDecoration(labelText: context.loc.name),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                validator: (value) => GlobalValidator.validateTextIsEmpty(
                  value ?? '',
                  errorMessage: context.loc.thisFieldCantBeEmpty,
                ),
                decoration: InputDecoration(labelText: context.loc.description),
              ),
            ],
          ),
        ),
      ),
      actions: [
        PlatformDialogAction(
          onPressed: () => context.pop(),
          child: Text(context.loc.cancel),
        ),
        PlatformDialogAction(
          onPressed: () {
            if (!_isValidData) {
              return;
            }
            _formKey.currentState?.save();
            context.pop();
            widget.onSubmit(AdminAddEditCategoryDialogData(
              name: _nameController.text,
              description: _descriptionController.text,
              imageFile: _imageFile,
            ));
          },
          child: Text(
            widget.initialCategory != null ? context.loc.edit : context.loc.add,
          ),
        ),
      ],
    );
  }
}
