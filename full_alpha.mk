#
# Copyright 2013 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Include the common definitions and packages
# This is done before inherit to override any duplicates
include $(LOCAL_PATH)/common.mk

# Inherit all packages from the "full" Android product
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_x86_64.mk)

# Override inherited values
PRODUCT_NAME := full_alpha
PRODUCT_DEVICE := alpha
PRODUCT_MODEL := Full Alpha Image for Emulator

# Enable overlays
DEVICE_PACKAGE_OVERLAYS := $(LOCAL_PATH)/overlay

# Include SELinux policy additions for our services
BOARD_SEPOLICY_DIRS += device/newcircle/alpha/sepolicy

# Add our device-specific packages
PRODUCT_PACKAGES += MrknLogNative
PRODUCT_PACKAGES += MrknLogClient
