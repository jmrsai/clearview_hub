#
# Generated file, do not edit.
#

list(APPEND FLUTTER_PLUGIN_LIST
  audioplayers_windows
  battery_plus
  cloud_firestore
  connectivity_plus
  face_detection_tflite
  file_selector_windows
  firebase_app_check
  firebase_auth
  firebase_core
  firebase_database
  firebase_remote_config
  flutter_blue_plus_winrt
  flutter_inappwebview_windows
  flutter_secure_storage_windows
  flutter_timezone
  flutter_tts
  hand_detection
  local_auth_windows
  permission_handler_windows
  printing
  speech_to_text_windows
  url_launcher_windows
)

list(APPEND FLUTTER_FFI_PLUGIN_LIST
  flutter_litert
  flutter_local_notifications_windows
  jni
  tflite_flutter
)

set(PLUGIN_BUNDLED_LIBRARIES)

foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_subdirectory(flutter/ephemeral/.plugin_symlinks/${plugin}/windows plugins/${plugin})
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin}_plugin)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES $<TARGET_FILE:${plugin}_plugin>)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES ${${plugin}_bundled_libraries})
endforeach(plugin)

foreach(ffi_plugin ${FLUTTER_FFI_PLUGIN_LIST})
  add_subdirectory(flutter/ephemeral/.plugin_symlinks/${ffi_plugin}/windows plugins/${ffi_plugin})
  list(APPEND PLUGIN_BUNDLED_LIBRARIES ${${ffi_plugin}_bundled_libraries})
endforeach(ffi_plugin)
