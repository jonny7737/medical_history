import 'package:hive/hive.dart';
import 'package:medical_history/core/constants.dart';

/**
 * TODO: To generate '.g.' file, open terminal and run this command
    flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'doctor_data.g.dart';

@HiveType(typeId: kDocHiveTypeId)
class DoctorData extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String owner;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String phone;

  DoctorData({this.id, this.owner, this.name, this.phone});

  DoctorData copyWith({int id}) {
    if (id == null) id = this.id;
    DoctorData _copy = DoctorData(id: id, owner: this.owner, name: this.name, phone: this.phone);
    return _copy;
  }

  int compareTo(DoctorData otherDoctor) => name.compareTo(otherDoctor.name);

  String toString() {
    return name;
  }
}
