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
# nmake Makefile for jnetman.dll and jnetman.jar
#
!IF "$(CFG)" == ""
CFG=netman - Win32 Debug
!MESSAGE No configuration specified. Defaulting to netman - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "netman - Win32 Release" && "$(CFG)" != "netman - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "netman.mak" CFG="netman - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "netman - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "netman - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "netman - Win32 Release"

OUTDIR=$(OBJDEST)\netman
INTDIR=$(OBJDEST)\netman
# Begin Custom Macros
OutDir=$(OBJDEST)\netman
# End Custom Macros

ALL : "$(OUTDIR)\jnetman_wrap.cxx" "$(OUTDIR)\jnetman.dll" "$(OUTDIR)\jnetman.jar"


CLEAN :
	-@erase "$(INTDIR)\jnetman_wrap.cxx "
	-@erase "$(INTDIR)\jnetman.dll"
	-@erase "$(INTDIR)\jnetman.lib"
	-@erase "$(INTDIR)\*.obj"
	-@erase "$(INTDIR)\*.java"
	-@erase "$(INTDIR)\jnetman.jar"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /ML /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\netman.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

RSC=rc.exe
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\netman.bsc" 
BSC32_SBRS= \

SWIG=swig.exe
SWIG_OPTS=-v -outdir "$(OUTDIR)"
	
LINK32=link.exe
LINK32_LIBS=wsock32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib  rpcrt4.lib uuid.lib odbc32.lib odbccp32.lib winmm.lib netapi32.lib
LINK32_FLAGS=/nologo /DLL /SUBSYSTEM:WINDOWS /pdb:"$(OUTDIR)\jnetman.pdb" /out:"$(OUTDIR)\jnetman.dll"
LINK32_OBJS= \
	"$(INTDIR)\netman.obj" \
	"$(INTDIR)\jnetman_wrap.obj"

"$(OUTDIR)\jnetman_wrap.cxx" : "$(OUTDIR)"
	$(SWIG) $(SWIG_OPTS) -java -package org.bpi.jnetman -c++ jnetman.i
	move jnetman_wrap.cxx $(OUTDIR)

"$(OUTDIR)\jnetman.dll" :  "$(OUTDIR)\netman.obj" "$(OUTDIR)\jnetman_wrap.obj"
	$(LINK32) $(LINK32_FLAGS) $(LINK32_LIBS) $(LINK32_OBJS)

!ELSEIF  "$(CFG)" == "netman - Win32 Debug"

OUTDIR=$(OBJDEST)\netman
INTDIR=$(OBJDEST)\netman
# Begin Custom Macros
OutDir=$(OBJDEST)\netman
# End Custom Macros

ALL : "$(OUTDIR)\jnetman_wrap.cxx" "$(OUTDIR)\jnetman.dll" "$(OUTDIR)\jnetman.jar"


CLEAN :
	-@erase "$(INTDIR)\jnetman_wrap.cxx "
	-@erase "$(INTDIR)\jnetman.dll"
	-@erase "$(INTDIR)\jnetman.lib"
	-@erase "$(INTDIR)\*.obj"
	-@erase "$(INTDIR)\*.java"
	-@erase "$(INTDIR)\jnetman.jar"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MLd /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\netman.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

RSC=rc.exe
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\netman.bsc" 
BSC32_SBRS= \

SWIG=swig.exe
SWIG_OPTS=-v -outdir "$(OUTDIR)"
	
LINK32=link.exe 
LINK32_LIBS=wsock32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib  rpcrt4.lib uuid.lib odbc32.lib odbccp32.lib winmm.lib netapi32.lib
LINK32_FLAGS=/nologo /DLL /SUBSYSTEM:WINDOWS /pdb:"$(OUTDIR)\jnetman.pdb" /debug /out:"$(OUTDIR)\jnetman.dll"
LINK32_OBJS= \
	"$(INTDIR)\netman.obj" \
	"$(INTDIR)\jnetman_wrap.obj"

"$(OUTDIR)\jnetman_wrap.cxx" : "$(OUTDIR)"
	$(SWIG) $(SWIG_OPTS) -java -package org.bpi.jnetman -c++ jnetman.i
	move jnetman_wrap.cxx "$(OUTDIR)"

"$(OUTDIR)\jnetman.dll" :  "$(OUTDIR)\netman.obj" "$(OUTDIR)\jnetman_wrap.obj"
	$(LINK32) $(LINK32_FLAGS) $(LINK32_LIBS) $(LINK32_OBJS)

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("netman.dep")
!INCLUDE "netman.dep"
!ELSE 
!MESSAGE Warning: cannot find "netman.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "netman - Win32 Release" || "$(CFG)" == "netman - Win32 Debug"

SOURCE=.\netman.cpp

"$(INTDIR)\netman.obj" : $(SOURCE) "$(INTDIR)"


SOURCE="$(OUTDIR)\jnetman_wrap.cxx"

"$(INTDIR)\jnetman_wrap.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) /I"$(JAVA_HOME)\include" /I"$(JAVA_HOME)\include\win32" /I. $(SOURCE)

$(OUTDIR)\jnetman.jar :	$(SOURCE) "$(OUTDIR)"
	javac -d $(OUTDIR) $(OUTDIR)\*.java
	(cd  $(OUTDIR) && jar cf $(OUTDIR)\jnetman.jar org)

!ENDIF
