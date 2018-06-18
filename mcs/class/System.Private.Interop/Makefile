thisdir = class/System.Private.Interop
SUBDIRS = 
include ../../build/rules.make

RESOURCE_FILES =

LIBRARY = System.Private.Interop.dll
LIB_REFS = System
LIB_MCS_FLAGS = -debug /unsafe /nowarn:3021 -d:TARGET_CORE_API_SET -d:CORECLR -d:ENABLE_MIN_WINRT

RESX_RESOURCE_STRING = ../../../external/corert/src/System.Private.Interop/src/Resources/Strings.resx

NO_TEST = yes

include ../../build/library.make
