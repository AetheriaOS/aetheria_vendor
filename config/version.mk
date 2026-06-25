PRODUCT_VERSION_MAJOR = 1
PRODUCT_VERSION_MINOR = 0

ifeq ($(AETHERIA_VERSION_APPEND_TIME_OF_DAY),true)
    AETHERIA_BUILD_DATE := $(shell date -u +%Y%m%d_%H%M%S)
else
    AETHERIA_BUILD_DATE := $(shell date -u +%Y%m%d)
endif

# Random tagline
AETHERIA_TAGLINES := \
    "Where imagination meets the cosmos" \
    "Beyond the horizon of possibility" \
    "Crafted for those who dare to dream" \
    "The universe in your hands" \
    "Redefining the boundaries of Android" \
    "Born from the stars, built for you" \
    "Experience the art of pure Android" \
    "Elevate your digital existence" \
    "Forged in the depths of the aether" \
    "A new dimension of Android freedom" \
    "Precision crafted, endlessly refined" \
    "Where performance meets elegance" \
    "Unlock the full potential of your device" \
    "Inspired by the cosmos, built for earth" \
    "Light as air, powerful as the universe" \
    "The OS that thinks beyond limits" \
    "Crafted with love, powered by passion" \
    "Your device, reimagined" \
    "Seamless. Elegant. Aetheria." \
    "Float above the ordinary"

AETHERIA_TAGLINE := $(shell echo "$(AETHERIA_TAGLINES)" | tr ' ' '\n' | grep '"' | shuf -n 1 | tr -d '"')

# Get GitHub username via SSH
AETHERIA_GITHUB_USER := $(shell ssh -T git@github.com 2>&1 | grep -oP '(?<=Hi ).*(?=!)')

# Check against official devices JSON
AETHERIA_OFFICIAL_JSON := $(shell curl -s https://raw.githubusercontent.com/AetheriaOS/aetheria_official_devices/main/$(AETHERIA_BUILD).json)

AETHERIA_CHECK_USER := $(shell echo '$(AETHERIA_OFFICIAL_JSON)' | python3 -c "import sys,json; d=json.load(sys.stdin); print('match') if d.get('github_username')=='$(AETHERIA_GITHUB_USER)' else print('nomatch')" 2>/dev/null)

ifeq ($(AETHERIA_CHECK_USER), match)
    AETHERIA_BUILDTYPE := OFFICIAL
    AETHERIA_MAINTAINER := $(shell echo '$(AETHERIA_OFFICIAL_JSON)' | python3 -c "import sys,json; print(json.load(sys.stdin)['maintainer'])" 2>/dev/null)
else
    AETHERIA_BUILDTYPE := UNOFFICIAL
    AETHERIA_MAINTAINER := Unknown
endif

AETHERIA_EXTRAVERSION :=
ifeq ($(AETHERIA_BUILDTYPE), UNOFFICIAL)
    ifneq ($(TARGET_UNOFFICIAL_BUILD_ID),)
        AETHERIA_EXTRAVERSION := -$(TARGET_UNOFFICIAL_BUILD_ID)
    endif
endif

AETHERIA_VERSION_SUFFIX := $(AETHERIA_BUILD_DATE)-$(AETHERIA_BUILDTYPE)$(AETHERIA_EXTRAVERSION)-$(AETHERIA_BUILD)

# Internal version
AETHERIA_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(AETHERIA_VERSION_SUFFIX)
# Display version
AETHERIA_DISPLAY_VERSION := $(PRODUCT_VERSION_MAJOR)-$(AETHERIA_VERSION_SUFFIX)

# AetheriaOS version properties
PRODUCT_PRODUCT_PROPERTIES += \
    ro.aetheria.version=$(AETHERIA_VERSION) \
    ro.aetheria.display.version=$(AETHERIA_DISPLAY_VERSION) \
    ro.aetheria.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.aetheria.releasetype=$(AETHERIA_BUILDTYPE) \
    ro.aetheria.maintainer=$(AETHERIA_MAINTAINER) \
    ro.aetheria.buildtype=$(AETHERIA_BUILDTYPE) \
    ro.aetheria.tagline=$(AETHERIA_TAGLINE)
