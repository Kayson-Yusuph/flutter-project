import 'package:scoped_model/scoped_model.dart';

class AppSetting extends Model {
  bool nightMode = false;

  setMode() {
    nightMode = !nightMode;
  }
}
