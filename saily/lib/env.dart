/// Must define variable in flutter
///
/// #!/bin/bash
/// DATE=$(date +%Y-%m-%d:%H:%M:%S)
/// GITVERSION=$(git describe --always)
///
/// flutter build web --release --dart-define=PLATFORM=web --dart-define=DATE=$DATE --dart-define=GITVERSION=$GITVERSION
///

enum FEATURES {
  console_comm,
  persistent_console_comm,
  ble_comm,
  mqtt_comm,
  ws_comm,
  splash_screen,
}

const Map<String, List<bool>> featurePerPlatform = {
  //            console_comm      persistent_console_comm       ...               splash_screen
  "debug": [
    true,       // console_comm
    true,       // persistent_console_comm 
    true,       // ble_comm
    true,       // mqtt_comm
    true,       // ws_comm 
    false,      // splash_screen
  ],
  "web": [
    true,
    true,
    false,
    true,
    true,
    false,
  ],
};

class Env {
  static const gitVersion =
      String.fromEnvironment("GITVERSION", defaultValue: "debug");
  static const gitBranch =
      String.fromEnvironment("GITBRANCH", defaultValue: "debug");
  static const date = String.fromEnvironment("DATE", defaultValue: "debug");
  static const platform =
      String.fromEnvironment("PLATFORM", defaultValue: "debug");

  static String str() {
    return "git: $gitVersion -b ${gitBranch}\ndate: $date\npaltform: $platform";
  }

  static bool isConsoleCommAvailable() {
    var ret = featurePerPlatform[platform];
    if (ret == null) {
      return false;
    }
    return ret[FEATURES.console_comm.index];
  }

  static bool isPersistentConsoleCommAvailable() {
    var ret = featurePerPlatform[platform];
    if (ret == null) {
      return false;
    }
    return ret[FEATURES.persistent_console_comm.index];
  }

  static bool isBleCommAvailable() {
    var ret = featurePerPlatform[platform];
    if (ret == null) {
      return false;
    }
    return ret[FEATURES.ble_comm.index];
  }

  static bool isMqttCommAvailable() {
    var ret = featurePerPlatform[platform];
    if (ret == null) {
      return false;
    }
    return ret[FEATURES.mqtt_comm.index];
  }

  static bool isWsCommAvailable() {
    var ret = featurePerPlatform[platform];
    if (ret == null) {
      return false;
    }
    return ret[FEATURES.ws_comm.index];
  }

  static bool isSplashScreenAvailable() {
    var ret = featurePerPlatform[platform];
    if (ret == null) {
      return false;
    }
    return ret[FEATURES.splash_screen.index];
  }
}
