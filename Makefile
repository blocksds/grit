# SPDX-License-Identifier: CC0-1.0
#
# SPDX-FileContributor: Antonio Niño Díaz, 2023-2025

# Source code paths
# -----------------

INCLUDEDIRS	:= cldib extlib libgrit libplum srcgrit

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

# Version string handling
# -----------------------

# Try to generate a version string if it isn't already provided
ifeq ($(VERSION_STRING),)
    # Try an exact match with a tag (e.g. v1.12.1)
    VERSION_STRING	:= $(shell git describe --tags --exact-match --dirty 2>/dev/null)
    ifeq ($(VERSION_STRING),)
        # Try a non-exact match (e.g. v1.12.1-3-g67a811a)
        VERSION_STRING	:= $(shell git describe --tags --dirty 2>/dev/null)
        ifeq ($(VERSION_STRING),)
            # If no version is provided by the user or git, fall back to this
            VERSION_STRING	:= DEV
        endif
    endif
endif

# Defines passed to all files
# ---------------------------

DEFINES		:= -DVERSION_STRING=\"$(VERSION_STRING)\"

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

WARNFLAGS_CXX	:= -Wall -Wextra -Wno-unused-result -Wno-sign-compare \
		   -Wno-format-truncation -Wno-class-memaccess

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
