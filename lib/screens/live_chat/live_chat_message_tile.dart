import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/live_chat/models/chat_message.dart';
import '../../l10n/app_localizations.dart';
import '../../logic/settings/settings_cubit.dart';
import '../../logic/user/user_cubit.dart';

class LiveChatMessageTile extends StatelessWidget {
  const LiveChatMessageTile({required this.message, super.key});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserCubit>().state.userCredential?.user ??
        (throw StateError('You need to be authenticated in order to chat'));
    final isMe = message.isMe(user.userId);
    final messageAlignment = isMe ? Alignment.topRight : Alignment.topLeft;
    if (context.read<SettingsCubit>().state.useClassicMsgBubble) {
      return Align(
        alignment: messageAlignment,
        child: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
          width: 140,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft:
                  !isMe ? const Radius.circular(0) : const Radius.circular(12),
              bottomRight:
                  isMe ? const Radius.circular(0) : const Radius.circular(12),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                isMe ? user.info.labOwnerName : context.loc.admin,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                message.text,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }
    return FractionallySizedBox(
      alignment: messageAlignment,
      widthFactor: 0.8,
      child: Align(
        alignment: messageAlignment,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft:
                  !isMe ? const Radius.circular(0) : const Radius.circular(12),
              bottomRight:
                  isMe ? const Radius.circular(0) : const Radius.circular(12),
            ),
            child: BubbleBackground(
              colors: [
                if (!isMe) ...const [
                  Color(0xFF6C7689),
                  Color(0xFF3A364B),
                ] else ...const [
                  Color(0xFF19B7FF),
                  Color(0xFF491CCB),
                ],
              ],
              child: DefaultTextStyle.merge(
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(message.text),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class BubbleBackground extends StatelessWidget {
  const BubbleBackground({
    required this.colors,
    super.key,
    this.child,
  });

  final List<Color> colors;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BubblePainter(
        colors: colors,
        scrollable: Scrollable.of(context),
        bubbleContext: context,
      ),
      child: child,
    );
  }
}

class BubblePainter extends CustomPainter {
  const BubblePainter({
    required List<Color> colors,
    required ScrollableState scrollable,
    required BuildContext bubbleContext,
  })  : _colors = colors,
        _scrollable = scrollable,
        _bubbleContext = bubbleContext;

  final ScrollableState _scrollable;
  final BuildContext _bubbleContext;
  final List<Color> _colors;

  @override
  void paint(Canvas canvas, Size size) {
    final scrollableBox = _scrollable.context.findRenderObject() as RenderBox;
    final scrollableRect = Offset.zero & scrollableBox.size;
    final bubbleBox = _bubbleContext.findRenderObject() as RenderBox;

    final origin =
        bubbleBox.localToGlobal(Offset.zero, ancestor: scrollableBox);
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        scrollableRect.topCenter,
        scrollableRect.bottomCenter,
        _colors,
        [0.0, 1.0],
        TileMode.clamp,
        Matrix4.translationValues(-origin.dx, -origin.dy, 0.0).storage,
      );
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant BubblePainter oldDelegate) {
    return oldDelegate._scrollable != _scrollable ||
        oldDelegate._bubbleContext != _bubbleContext ||
        oldDelegate._colors != _colors;
  }
}
