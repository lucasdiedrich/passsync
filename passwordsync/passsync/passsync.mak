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
# nmake Makefile for passsync.exe
#
!IF "$(CFG)" == ""
CFG=passsync - Win32 Debug
!MESSAGE No configuration specified. Defaulting to passsync - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "passsync - Win32 Release" && "$(CFG)" != "passsync - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "passsync.mak" CFG="passsync - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "passsync - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "passsync - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "passsync - Win32 Release"

OUTDIR=$(OBJDEST)\passsync
INTDIR=$(OBJDEST)\passsync
# Begin Custom Macros
OutDir=$(OBJDEST)\passsync
# End Custom Macros

ALL : "$(OUTDIR)\passsync.exe"


CLEAN :
	-@erase "$(INTDIR)\ntservice.obj"
	-@erase "$(INTDIR)\passhand.obj"
	-@erase "$(INTDIR)\service.obj"
	-@erase "$(INTDIR)\subuniutil.obj"
	-@erase "$(INTDIR)\syncserv.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\passsync.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /ML /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\passsync.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\passsync.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:no /pdb:"$(OUTDIR)\passsync.pdb" /machine:I386 /out:"$(OUTDIR)\passsync.exe" 
LINK32_OBJS= \
	"$(INTDIR)\ntservice.obj" \
	"$(INTDIR)\passhand.obj" \
	"$(INTDIR)\service.obj" \
	"$(INTDIR)\subuniutil.obj" \
	"$(INTDIR)\syncserv.obj"

"$(OUTDIR)\passsync.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "passsync - Win32 Debug"

OUTDIR=$(OBJDEST)\passsync
INTDIR=$(OBJDEST)\passsync
# Begin Custom Macros
OutDir=$(OBJDEST)\passsync
# End Custom Macros

ALL : "$(OUTDIR)\passsync.exe"


CLEAN :
	-@erase "$(INTDIR)\ntservice.obj"
	-@erase "$(INTDIR)\passhand.obj"
	-@erase "$(INTDIR)\service.obj"
	-@erase "$(INTDIR)\subuniutil.obj"
	-@erase "$(INTDIR)\syncserv.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\passsync.exe"
	-@erase "$(OUTDIR)\passsync.ilk"
	-@erase "$(OUTDIR)\passsync.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MLd /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /Fp"$(INTDIR)\passsync.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\passsync.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=nss3.lib libplc4.lib libnspr4.lib nsldappr32v50.lib nsldapssl32v50.lib nsldap32v50.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:yes /pdb:"$(OUTDIR)\passsync.pdb" /debug /machine:I386 /out:"$(OUTDIR)\passsync.exe" 
LINK32_OBJS= \
	"$(INTDIR)\ntservice.obj" \
	"$(INTDIR)\passhand.obj" \
	"$(INTDIR)\service.obj" \
	"$(INTDIR)\subuniutil.obj" \
	"$(INTDIR)\syncserv.obj"

"$(OUTDIR)\passsync.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("passsync.dep")
!INCLUDE "passsync.dep"
!ELSE 
!MESSAGE Warning: cannot find "passsync.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "passsync - Win32 Release" || "$(CFG)" == "passsync - Win32 Debug"
SOURCE=.\ntservice.cpp

"$(INTDIR)\ntservice.obj" : $(SOURCE) "$(INTDIR)"


SOURCE=..\passhand.cpp

"$(INTDIR)\passhand.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)


SOURCE=.\service.cpp

"$(INTDIR)\service.obj" : $(SOURCE) "$(INTDIR)"


SOURCE=.\subuniutil.cpp

"$(INTDIR)\subuniutil.obj" : $(SOURCE) "$(INTDIR)"


SOURCE=.\syncserv.cpp

"$(INTDIR)\syncserv.obj" : $(SOURCE) "$(INTDIR)"



!ENDIF 

