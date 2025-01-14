import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubuntu_service/ubuntu_service.dart';

import '../../build_context_x.dart';
import '../../common.dart';
import '../../data.dart';
import '../../library.dart';
import 'download_model.dart';

class DownloadButton extends StatelessWidget {
  const DownloadButton({
    super.key,
    this.iconSize,
    required this.audio,
    required this.addPodcast,
  });

  static Widget create({
    required BuildContext context,
    double? iconSize,
    required Audio? audio,
    required void Function()? addPodcast,
  }) {
    return ChangeNotifierProvider(
      create: (_) => DownloadModel(getService<LibraryService>()),
      child: DownloadButton(
        iconSize: iconSize,
        audio: audio,
        addPodcast: addPodcast,
      ),
    );
  }

  final double? iconSize;
  final Audio? audio;
  final void Function()? addPodcast;

  @override
  Widget build(BuildContext context) {
    final theme = context.t;
    final model = context.read<DownloadModel>();
    final value = context.select((DownloadModel m) => m.value);
    return Stack(
      alignment: Alignment.center,
      children: [
        Progress(
          value: value == null || value == 1.0 ? 0 : value,
          backgroundColor: Colors.transparent,
        ),
        IconButton(
          icon: Icon(
            audio?.path != null ? Iconz().downloadFilled : Iconz().download,
          ),
          onPressed: () {
            if (audio?.path != null) {
              model.deleteDownload(context: context, audio: audio);
            } else {
              addPodcast?.call();
              model.startDownload(context: context, audio: audio);
            }
          },
          iconSize: iconSize,
          color: audio?.path != null ? theme.colorScheme.primary : null,
        ),
      ],
    );
  }
}
