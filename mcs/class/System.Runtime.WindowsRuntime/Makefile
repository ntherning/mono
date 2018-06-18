thisdir = class/System.Runtime.WindowsRuntime
SUBDIRS = 
include ../../build/rules.make

RESOURCE_FILES =

LIBRARY = System.Runtime.WindowsRuntime.dll
LIB_REFS = System Facades/System.Runtime
# Facades/System.Runtime.InteropServices.WindowsRuntime Facades/System.Runtime
LIB_MCS_FLAGS = /unsafe /nowarn:3021 /nowarn:436 -d:netstandard -d:FEATURE_APPX \
	-r:'./Windows.winmd' \
	-r:System_Runtime_Extensions=$(topdir)/class/lib/$(PROFILE)/mscorlib.dll

RESX_RESOURCE_STRING = ../../../external/corefx/src/System.Runtime.WindowsRuntime/src/Resources/Strings.resx

NO_TEST = yes

include ../../build/library.make
