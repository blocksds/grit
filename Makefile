# SPDX-License-Identifier: CC0-1.0
#
# SPDX-FileContributor: Antonio Niño Díaz, 2023-2024

# Source code paths
# -----------------

INCLUDEDIRS	:= cldib extlib libgrit libplum srcgrit

# Try to find the SDK version if it wasn't already provided e.g. by the parent Makefile
SDK_VERSION	?= $(shell git describe --tags --exact-match --dirty 2>/dev/null)

# Fallback to commit hash
ifeq ($(SDK_VERSION),)
    # --exclude to prevent any older tags from being displayed
    VERSION_ID	:= "commit $(shell git describe --always --dirty --exclude '*' 2>/dev/null)"
else
    VERSION_ID	:= "BlocksDS $(SDK_VERSION)"
endif

# Source files
# ------------

SOURCES_C	:= \
	libplum/libplum.c

SOURCES_CPP	:= \
	cldib/cldib_adjust.cpp \
	cldib/cldib_conv.cpp \
	cldib/cldib_core.cpp \
	cldib/cldib_tmap.cpp \
	cldib/cldib_tools.cpp \
	cldib/cldib_wu.cpp \
	libgrit/cprs.cpp \
	libgrit/cprs_huff.cpp \
	libgrit/cprs_lz.cpp \
	libgrit/cprs_rle.cpp \
	libgrit/grit_core.cpp \
	libgrit/grit_misc.cpp \
	libgrit/grit_prep.cpp \
	libgrit/grit_shared.cpp \
	libgrit/grit_xp.cpp \
	libgrit/logger.cpp \
	libgrit/pathfun.cpp \
	extlib/plum.cpp \
	srcgrit/cli.cpp \
	srcgrit/grit_main.cpp

# Defines passed to all files
# ---------------------------

DEFINES		:= -DVERSION_ID=\"$(VERSION_ID)\"

# Libraries
# ---------

LIBS		:=
LIBDIRS		:=

# Build artifacts
# ---------------

NAME		:= grit
BUILDDIR	:= build
ELF		:= $(NAME)

# Tools
# -----

STRIP		:= -s
BINMODE		:= 755

HOSTCC		?= gcc
HOSTCXX		?= g++
CP		:= cp
MKDIR		:= mkdir
RM		:= rm -rf
MAKE		:= make
INSTALL		:= install

# Verbose flag
# ------------

ifeq ($(VERBOSE),1)
V		:=
else
V		:= @
endif

# Compiler and linker flags
# -------------------------

WARNFLAGS_C	:= -Wall \
		   -Wno-maybe-uninitialized -Wno-dangling-else -Wno-parentheses

# As of GCC 14, implicit function declarations are considered errors.
# However, libplum in some cases tries to call the C11 standard function
# aligned_alloc, which is not provided on MinGW nor is it necessary there.
# This is a workaround which demotes the relevant error back to a warning.
# If it ever becomes necessary, the linking will fail regardless.
WARNFLAGS_C	+= -Wno-implicit-function-declaration

WARNFLAGS_CXX	:= -Wall -Wno-misleading-indentation -Wno-unused-result \
		   -Wno-comment -Wno-unused-variable -Wno-sign-compare \
		   -Wno-parentheses -Wno-format-truncation \
		   -Wno-class-memaccess -Wno-unused-value \
		   -Wno-unused-but-set-variable -Wno-maybe-uninitialized

ifeq ($(SOURCES_CPP),)
    HOSTLD	:= $(HOSTCC)
else
    HOSTLD	:= $(HOSTCXX)
endif

INCLUDEFLAGS	:= $(foreach path,$(INCLUDEDIRS),-I$(path)) \
		   $(foreach path,$(LIBDIRS),-I$(path)/include)

LIBDIRSFLAGS	:= $(foreach path,$(LIBDIRS),-L$(path)/lib)

CFLAGS		+= -std=gnu17 $(WARNFLAGS_C) $(DEFINES) $(INCLUDEFLAGS) -O3

CXXFLAGS	+= -std=gnu++14 $(WARNFLAGS_CXX) $(DEFINES) $(INCLUDEFLAGS) -O3

LDFLAGS		+= $(LIBDIRSFLAGS) $(LIBS)

# Intermediate build files
# ------------------------

OBJS		:= $(addsuffix .o,$(addprefix $(BUILDDIR)/,$(SOURCES_C))) \
		   $(addsuffix .o,$(addprefix $(BUILDDIR)/,$(SOURCES_CPP)))

DEPS		:= $(OBJS:.o=.d)

# Targets
# -------

.PHONY: all clean install

all: $(ELF)

$(ELF): $(OBJS)
	@echo "  HOSTLD  $@"
	$(V)$(HOSTLD) -o $@ $(OBJS) $(LDFLAGS)

clean:
	@echo "  CLEAN  "
	$(V)$(RM) $(ELF) $(BUILDDIR)

INSTALLDIR	?= /opt/blocksds/core/tools/grit
INSTALLDIR_ABS	:= $(abspath $(INSTALLDIR))

install: all
	@echo "  INSTALL $(INSTALLDIR_ABS)"
	@test $(INSTALLDIR_ABS)
	$(V)$(RM) $(INSTALLDIR_ABS)
	$(V)$(INSTALL) -d $(INSTALLDIR_ABS)
	$(V)$(INSTALL) $(STRIP) -m $(BINMODE) $(NAME) $(INSTALLDIR_ABS)
	$(V)$(CP) COPYING $(INSTALLDIR_ABS)

# Rules
# -----

$(BUILDDIR)/%.c.o : %.c
	@echo "  HOSTCC  $<"
	@$(MKDIR) -p $(@D)
	$(V)$(HOSTCC) $(CFLAGS) -MMD -MP -c -o $@ $<

$(BUILDDIR)/%.cpp.o : %.cpp
	@echo "  HOSTCXX $<"
	@$(MKDIR) -p $(@D)
	$(V)$(HOSTCXX) $(CXXFLAGS) -MMD -MP -c -o $@ $<

# Include dependency files if they exist
# --------------------------------------

-include $(DEPS)
