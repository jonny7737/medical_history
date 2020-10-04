import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_history/core/helpers/hero_dialog_route.dart';
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/models/med_data.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:medical_history/ui/view_model/screen_info_provider.dart';
import 'package:medical_history/ui/views/meds/meds_view.dart';
import 'package:medical_history/ui/views/meds/meds_viewmodel.dart';
import 'package:medical_history/ui/views/widgets/med_image_hero.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:sized_context/sized_context.dart';

class ListViewCard extends HookWidget {
  final Logger _l = locator();
  final ScreenInfoViewModel _s = locator();

  ListViewCard({
    Key key,
    @required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final String sectionName = this.runtimeType.toString();
    _l.initSectionPref(sectionName);

    MedsViewModel _model = useProvider(medsViewModel);
    MedData medData = _model.medList[index];

    return Card(
      margin: EdgeInsets.only(
        top: context.heightPct(0.015),
        left: context.widthPct(0.025),
        right: context.widthPct(0.025),
      ),
      child: Stack(
        children: <Widget>[
          buildImageWidget(_model, context, medData, _s),
          buildMedNameWidget(context, _s, medData),
          buildManufacturerWidget(context, medData, _s),
          buildDoctorNameWidget(context, _s, _model, medData),
          buildMedFrequencyWidget(context, _s, medData),
        ],
      ),
    );
  }

  Positioned buildMedFrequencyWidget(
      BuildContext context, ScreenInfoViewModel _s, MedData medData) {
    return Positioned(
      right: context.widthPct(0.050),
      bottom: _s.isiOS ? 6.0 : 4.0,
      child: Text(
        medData.frequency,
        style: TextStyle(
          color: Colors.black,
          fontSize: context.heightPct(_s.isLargeScreen ? 0.020 : 0.025) * _s.fontScale,
        ),
      ),
    );
  }

  Positioned buildDoctorNameWidget(
      BuildContext context, ScreenInfoViewModel _s, MedsViewModel _model, MedData medData) {
    return Positioned(
      left: context.widthPct(_s.isLargeScreen ? 0.28 : 0.23),
      bottom: _s.isiOS ? 2.0 : 0.0,
      child: Text(
        'Dr. ${_model.getDoctorById(medData.doctorId).name}',
        style: TextStyle(
          color: Colors.black,
          fontSize: context.heightPct(_s.isLargeScreen ? 0.020 : 0.024) * _s.fontScale * 1.1,
        ),
      ),
    );
  }

  Positioned buildManufacturerWidget(
      BuildContext context, MedData medData, ScreenInfoViewModel _s) {
    return Positioned(
      right: context.widthPct(0.025),
      child: Text(
        medData.mfg.split(' ')[0],
        style: TextStyle(
          color: Colors.black,
          fontSize: context.heightPct(_s.isLargeScreen ? 0.020 : 0.025) * _s.fontScale,
        ),
      ),
    );
  }

  Positioned buildMedDoseWidget(BuildContext context, MedData medData, ScreenInfoViewModel _s) {
    return Positioned(
      right: context.widthPct(0.025),
      child: Text(
        medData.dose,
        style: TextStyle(
          color: Colors.black,
          fontSize: context.heightPct(_s.isLargeScreen ? 0.020 : 0.025) * _s.fontScale,
        ),
      ),
    );
  }

  Positioned buildMedNameWidget(BuildContext context, ScreenInfoViewModel _s, MedData medData) {
    return Positioned(
      left: context.widthPct(_s.isLargeScreen ? 0.28 : 0.23),
      right: context.widthPct(_s.isLargeScreen ? 0.28 : 0.23),
      top: context.heightPct(0.006),
      child: Container(
        width: context.widthPct(0.60),
        child: Text(
          '${medData.name}',
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
    );
  }

  GestureDetector buildImageWidget(
      MedsViewModel _model, BuildContext context, MedData medData, ScreenInfoViewModel _s) {
    bool goodToGo = _model.imageFile(medData.rxcui) != null || medData.imageURL != null;

    return GestureDetector(
      onTap: () {
        if (_model.detailCardVisible) {
          return;
        }
        Navigator.push(
          context,
          HeroDialogRoute(
            builder: (BuildContext context) {
              return MedImageHero(
                id: 'medImage${medData.rxcui}',
                imageFile: _model.imageFile(medData.rxcui),
                imageUrl: medData.imageURL,
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
          tag: 'medImage${medData.rxcui}',
          child: !goodToGo
              ? Container()
              : Container(
                  height: context.heightPct(0.08),
                  child: Image(
                    image: NetworkToFileImage(
                      file: _model.imageFile(medData.rxcui),
                      url: medData.imageURL,
                    ),
                    width: context.widthPct(_s.isLargeScreen ? 0.19 : 0.15),
                  ),
                ),
        ),
      ),
    );
  }
}
