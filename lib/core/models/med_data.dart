import 'package:hive/hive.dart';
import 'package:medical_history/core/constants.dart';

/**
 * TODO: To generate '.g.' file, open terminal and run this command
    flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'med_data.g.dart';

@HiveType(typeId: kMedHiveTypeId)
class MedData extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String rxcui;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String mfg;

  @HiveField(4)
  final String imageURL;

  @HiveField(5)
  final List<String> info;

  @HiveField(6)
  final List<String> warnings;

  @HiveField(7)
  final int doctorId;

  @HiveField(8)
  final String dose;

  @HiveField(9)
  final String frequency;

  @HiveField(10)
  final String owner;

  MedData(
      this.owner, this.id, this.rxcui, this.name, this.mfg, this.imageURL, this.info, this.warnings,
      {this.doctorId, this.dose = '0 mg', this.frequency = 'daily'});

  int compareTo(MedData otherMed) => rxcui.compareTo(otherMed.rxcui);

  MedData copyWith({int id, String mfg, int doctorId, String dose, String frequency}) {
    if (id == null) id = this.id;
    if (mfg == null) mfg = this.mfg;
    if (doctorId == null) doctorId = this.doctorId;
    if (doctorId == null) doctorId = 0;
    if (dose == null) dose = this.dose;
    if (frequency == null) frequency = this.frequency;

    MedData _medData = MedData(
      this.owner,
      id,
      this.rxcui,
      this.name,
      mfg,
      this.imageURL,
      this.info,
      this.warnings,
      doctorId: doctorId,
      dose: dose,
      frequency: frequency,
    );

    return _medData;
  }

  String toString({bool warningMsgs: false}) {
    List<String> theList;
    if (warningMsgs) {
      theList = warnings;
    } else {
      theList = info;
    }
    String medString = "";
    for (String str in theList) {
      medString += str + "\n\n";
    }
    return medString.trim();
  }

  String infoString() {
    String info = '';
    info += '$name\n';
    info += '$rxcui $mfg $imageURL';

    return info;
  }
}
