LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := audio.primary.$(TARGET_BOARD_PLATFORM)
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := qti
LOCAL_VENDOR_MODULE := true
LOCAL_ARM_MODE := arm

LOCAL_VINTF_FRAGMENTS := ../configs/common/manifest_non_qmaa.xml

LOCAL_CFLAGS += -Wno-macro-redefined
LOCAL_CFLAGS += -DSOUND_TRIGGER_PLATFORM_NAME=$(TARGET_BOARD_PLATFORM)
LOCAL_CFLAGS += -D_GNU_SOURCE
LOCAL_CFLAGS += -Wall -Werror
LOCAL_CFLAGS += -Wno-unused-variable
LOCAL_CFLAGS += -Wno-sign-compare
LOCAL_CFLAGS += -Wno-unused-parameter
LOCAL_CFLAGS += -Wno-unused-label
LOCAL_CFLAGS += -Wno-gnu-designator
LOCAL_CFLAGS += -Wno-typedef-redefinition
LOCAL_CFLAGS += -Wno-shorten-64-to-32
LOCAL_CFLAGS += -Wno-tautological-compare
LOCAL_CFLAGS += -Wno-unused-function
LOCAL_CFLAGS += -Wno-unused-local-typedef

LOCAL_C_INCLUDES += \
    system/media/audio_utils/include \
    external/expat/lib \
    vendor/qcom/opensource/core-utils/fwk-detect \
    vendor/qcom/opensource/pal \
    $(call include-path-for, audio-effects) \
    $(LOCAL_PATH)/audio_extn \
    $(LOCAL_PATH)/../hal/audio_extn

LOCAL_SRC_FILES := \
    AudioStream.cpp \
    AudioDevice.cpp \
    AudioVoice.cpp \
    audio_extn/soundtrigger.cpp \
    audio_extn/Gain.cpp \
    audio_extn/AudioExtn.cpp \
    ../hal/audio_extn/battery_listener.cpp

LOCAL_HEADER_LIBRARIES := libhardware_headers
LOCAL_STATIC_LIBRARIES := libhealthhalutils

LOCAL_SHARED_LIBRARIES := \
    libbase \
    liblog \
    libcutils \
    libdl \
    libaudioutils \
    libexpat \
    libhidlbase \
    libprocessgroup \
    libutils \
    libar-pal \
    android.hardware.health@1.0 \
    android.hardware.health@2.0 \
    android.hardware.power@1.2

ifeq ($(strip $(AUDIO_FEATURE_ENABLED_PAL_HIDL)),true)
  LOCAL_SHARED_LIBRARIES += \
    vendor.qti.hardware.pal@1.0-impl \
    vendor.qti.hardware.pal@1.0

  LOCAL_CFLAGS += -DPAL_HIDL_ENABLED
endif
ifeq ($(strip $(AUDIO_FEATURE_ENABLED_GEF_SUPPORT)),true)
    LOCAL_CFLAGS += -DAUDIO_GENERIC_EFFECT_FRAMEWORK_ENABLED
ifeq ($(strip $(AUDIO_FEATURE_ENABLED_INSTANCE_ID)), true)
    LOCAL_CFLAGS += -DINSTANCE_ID_ENABLED
endif
    LOCAL_SRC_FILES += audio_extn/Gef.cpp
endif

include $(BUILD_SHARED_LIBRARY)
