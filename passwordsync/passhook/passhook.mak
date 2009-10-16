#
# BEGIN COPYRIGHT BLOCK
# This Program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; version 2 of the License.
# 
# This Program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License along with
# this Program; if not, write to the Free Software Foundation, Inc., 59 Temple
# Place, Suite 330, Boston, MA 02111-1307 USA.
# 
# In addition, as a special exception, Red Hat, Inc. gives You the additional
# right to link the code of this Program with code not covered under the GNU
# General Public License ("Non-GPL Code") and to distribute linked combinations
# including the two, subject to the limitations in this paragraph. Non-GPL Code
# permitted under this exception must only link to the code of this Program
# through those well defined interfaces identified in the file named EXCEPTION
# found in the source code files (the "Approved Interfaces"). The files of
# Non-GPL Code may instantiate templates or use macros or inline functions from
# the Approved Interfaces without causing the resulting work to be covered by
# the GNU General Public License. Only Red Hat, Inc. may make changes or
# additions to the list of Approved Interfaces. You must obey the GNU General
# Public License in all respects for all of the Program code and other code used
# in conjunction with the Program except the Non-GPL Code covered by this
# exception. If you modify this file, you may extend this exception to your
# version of the file, but you are not obligated to do so. If you do not wish to
# provide this exception without modification, you must delete this exception
# statement from your version and license this file solely under the GPL without
# exception. 
# 
# 
# Copyright (C) 2005 Red Hat, Inc.
# All rights reserved.
# END COPYRIGHT BLOCK
#
# nmake Makefile for passhook.dll
#
!IF "$(CFG)" == ""
CFG=passhook - Win32 Debug
!MESSAGE No configuration specified. Defaulting to passhook - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "passhook - Win32 Release" && "$(CFG)" != "passhook - Win32 Debug" && "$(CFG)" != "passhook - Win64 Release" && "$(CFG)" != "passhook - Win64 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "passhook.mak" CFG="passhook - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "passhook - Win32 Release" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "passhook - Win32 Debug" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "passhook - Win64 Release" (based on "Win64 (x64) Dynamic-Link Library")
!MESSAGE "passhook - Win64 Debug" (based on "Win64 (x64) Dynamic-Link Library")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "passhook - Win64 Release" || "$(CFG)" == "passhook - Win64 Debug"
DEF64=/D "WIN64"
MACH=/MACHINE:X64
!ELSE
MACH=/MACHINE:X86
!ENDIF

OUTDIR=$(OBJDEST)\passhook
INTDIR=$(OBJDEST)\passhook
# Begin Custom Macros
OutDir=$(OBJDEST)\passhook
# End Custom Macros

CPP=cl.exe
COMMON_CPPFLAGS=/nologo /W3 /EHsc /D "WIN32" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "PASSHOOK_EXPORTS" /Fp"$(INTDIR)\passhook.pch" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD $(DEF64) /c 
OPT_CPPFLAGS=/MT /O2 /D "NDEBUG" $(COMMON_CPPFLAGS)
DBG_CPPFLAGS=/MTd /Gm /Zi /D "_DEBUG" /RTC1 $(COMMON_CPPFLAGS)

SYS_LIBS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib
MOZ_LIBS=nss3.lib nssutil3.lib libplc4.lib libnspr4.lib
LIBS=$(SYS_LIBS) $(MOZ_LIBS)

DEF_FILE= \
	".\passhook.def"
OBJS= \
	"$(INTDIR)\passhand.obj" \
	"$(INTDIR)\passhook.obj"

COMMON_LDFLAGS=$(MACH) /nologo /dll /pdb:"$(OUTDIR)\passhook.pdb" /out:$@ /implib:"$(OUTDIR)\passhook.lib" /def:$(DEF_FILE)
OPT_LDFLAGS=/incremental:no $(COMMON_LDFLAGS)
DBG_LDFLAGS=/incremental:yes /debug $(COMMON_LDFLAGS)

!IF  "$(CFG)" == "passhook - Win32 Release" || "$(CFG)" == "passhook - Win64 Release"
CPPFLAGS=$(OPT_CPPFLAGS)
LDFLAGS=$(OPT_LDFLAGS)
MTL_PROJ=/nologo /D "NDEBUG" /mktyplib203 /win32 
!ELSEIF  "$(CFG)" == "passhook - Win32 Debug" || "$(CFG)" == "passhook - Win64 Debug"
CPPFLAGS=$(DBG_CPPFLAGS)
LDFLAGS=$(DBG_LDFLAGS)
MTL_PROJ=/nologo /D "_DEBUG" /mktyplib203 /win32 
!ENDIF

CPP=cl.exe

RSC=rc.exe
BSC=bscmake.exe
BSC_FLAGS=/nologo /o"$(OUTDIR)\passhook.bsc" 
BSC_SBRS= \
	
LINK=link.exe
MTL=midl.exe

ALL : "$(OUTDIR)\passhook.dll"

CLEAN :
	-@erase "$(INTDIR)\passhand.obj"
	-@erase "$(INTDIR)\passhook.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\passhook.dll"
	-@erase "$(OUTDIR)\passhook.exp"
	-@erase "$(OUTDIR)\passhook.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPPFLAGS) $< 
<<

{.\}.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPPFLAGS) $< 
<<

{..\}.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPPFLAGS) $<
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPPFLAGS) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPPFLAGS) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPPFLAGS) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPPFLAGS) $< 
<<

"$(OUTDIR)\passhook.dll" : "$(OUTDIR)" $(DEF_FILE) $(OBJS)
    $(LINK) @<<
  $(LDFLAGS) $(LIBS) $(OBJS)
<<

!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("passhook.dep")
!INCLUDE "passhook.dep"
!ELSE 
!MESSAGE Warning: cannot find "passhook.dep"
!ENDIF 
!ENDIF 

