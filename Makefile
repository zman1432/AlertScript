include /var/theos/makefiles/common.mk

TWEAK_NAME = AlertScript
AlertScript_FILES = AlertScript.m
AlertScript_FRAMEWORKS = UIKit Foundation CoreFoundation
AlertScript_LDFLAGS = -lactivator -L../obj

include /var/theos/makefiles/tweak.mk
