import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:medical_history/core/helpers/hero_dialog_route.dart';
import 'package:medical_history/core/models/temp_med.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/core/services/med_lookup_service.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/ui/view_model/screen_info_provider.dart';
import 'package:medical_history/ui/views/widgets/med_image_hero.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:sized_context/sized_context.dart';

class ListViewCard extends HookWidget {
  final ScreenInfoViewModel _s = locator();
  final Logger _l = locator();
  final MedLookUpService _model = locator();

  ListViewCard({this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    final String sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);

    TempMed tempMed = _model.medFound;

    return Card(
      key: UniqueKey(),
      margin: EdgeInsets.only(
        top: context.heightPct(0.014),
        left: context.widthPct(0.025),
        right: context.widthPct(0.025),
      ),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                HeroDialogRoute(
                  builder: (BuildContext context) {
                    return MedImageHero(
                      id: 'medImage$index',
                      imageFile: null, //_model.imageFile(tempMed.rxcui),
                      imageUrl: tempMed.imageInfo.urls[index],
                    );
                  },
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPct(0.06),
                vertical: 2.0,
              ),
              child: Hero(
                tag: 'medImage$index',
                child: Container(
                  height: context.heightPct(0.08),
                  child: Image(
                    image: NetworkToFileImage(
                      file: null, //_model.imageFile(tempMed.rxcui),
                      url: tempMed.imageInfo.urls[index],
//                      debug: isLogging,
                    ),
                    width: context.widthPct(_s.isLargeScreen ? 0.19 : 0.15),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: context.widthPct(_s.isLargeScreen ? 0.28 : 0.23),
            right: context.widthPct(_s.isLargeScreen ? 0.28 : 0.23),
            top: context.heightPct(0.006),
            child: Container(
              width: context.widthPct(0.50),
              child: Text(
                tempMed.name,
                maxLines: 2,
                style: TextStyle(
                  color: Colors.black,
                  height: 0.9,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: context.heightPct(_s.isLargeScreen ? 0.022 : 0.028) * _s.fontScale,
                ),
              ),
            ),
          ),
          Positioned(
            right: context.widthPct(0.025),
            child: Text(
              _model.newMedDose,
              style: TextStyle(
                color: Colors.black,
                fontSize: context.heightPct(_s.isLargeScreen ? 0.020 : 0.025) * _s.fontScale,
              ),
            ),
          ),
          Positioned(
            left: context.widthPct(_s.isLargeScreen ? 0.28 : 0.23),
            bottom: _s.isiOS ? 2.0 : 0.0,
            child: Container(
              width: context.widthPct(0.60),
              child: Text(
                '${tempMed.imageInfo.mfgs[index]}',
                maxLines: 2,
                style: TextStyle(
                  color: Colors.black,
                  height: 0.9,
                  fontSize:
                      context.heightPct(_s.isLargeScreen ? 0.020 : 0.024) * _s.fontScale * 1.1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
