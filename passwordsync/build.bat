@rem //
@rem // BEGIN COPYRIGHT BLOCK
@rem // This Program is free software; you can redistribute it and/or modify it under
@rem // the terms of the GNU General Public License as published by the Free Software
@rem // Foundation; version 2 of the License.
@rem // 
@rem // This Program is distributed in the hope that it will be useful, but WITHOUT
@rem // ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
@rem // FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
@rem // 
@rem // You should have received a copy of the GNU General Public License along with
@rem // this Program; if not, write to the Free Software Foundation, Inc., 59 Temple
@rem // Place, Suite 330, Boston, MA 02111-1307 USA.
@rem // 
@rem // In addition, as a special exception, Red Hat, Inc. gives You the additional
@rem // right to link the code of this Program with code not covered under the GNU
@rem // General Public License ("Non-GPL Code") and to distribute linked combinations
@rem // including the two, subject to the limitations in this paragraph. Non-GPL Code
@rem // permitted under this exception must only link to the code of this Program
@rem // through those well defined interfaces identified in the file named EXCEPTION
@rem // found in the source code files (the "Approved Interfaces"). The files of
@rem // Non-GPL Code may instantiate templates or use macros or inline functions from
@rem // the Approved Interfaces without causing the resulting work to be covered by
@rem // the GNU General Public License. Only Red Hat, Inc. may make changes or
@rem // additions to the list of Approved Interfaces. You must obey the GNU General
@rem // Public License in all respects for all of the Program code and other code used
@rem // in conjunction with the Program except the Non-GPL Code covered by this
@rem // exception. If you modify this file, you may extend this exception to your
@rem // version of the file, but you are not obligated to do so. If you do not wish to
@rem // provide this exception without modification, you must delete this exception
@rem // statement from your version and license this file solely under the GPL without
@rem // exception. 
@rem // 
@rem // 
@rem // Copyright (C) 2005 Red Hat, Inc.
@rem // All rights reserved.
@rem // END COPYRIGHT BLOCK
@rem //

@echo off

if exist "c:\program files\support tools\bitsadmin.exe" (
   set BITSADMIN="c:\program files\support tools\bitsadmin.exe"
) else (
REM assume its in the PATH
   set BITSADMIN=bitsadmin
)
set DOWNLOAD=%BITSADMIN% /wrap /transfer passsyncbuild /download /priority normal
@rem set UZCMD=cscript //nologo "%CD%\unzip.vbs"
@rem HACK HACK HACK
@rem unzip.vbs just stopped working - gives File or Folder exists
@rem which is clearly not true
@ren so, fall back on MozillaTools
set UZCMD=C:\mozilla-build\info-zip\unzip.exe -q
@rem set UZCMD=cscript //nologo "%CD%\unzip.vbs"
@rem set DOWNLOAD=wget --no-directories
@rem set UZCMD=unzip -q

rem APPVER and CPU should be set in the batch file used to start
rem the command shell to set up the MS VC/SDK build environment
rem use goto to support if/elseif/elseif/else style statements
if [%APPVER%] == [6.0] goto WINVER60
rem else
goto WINVER61

:WINVER60
set WINVER=6.0
goto SETPLATFORM

:WINVER61
set WINVER=6.1
goto SETPLATFORM

:SETPLATFORM
if [%CPU%] == [AMD64] (
  set FLAG64=_64
  set USE64=1
  set PLATFORM=x86_64
  set LDAPDATE=20091019.1
  set MSMPLAT=x64
if [%BUILD_DEBUG%] == [optimize] (
    set OPTDBG=_OPT
    set CFG1="passsync - Win64 Release"
    set CFG2="passhook - Win64 Release"
    set FLV=opt
    set platdir=amd64
    set subdir=CRT
) else (
    set OPTDBG=_DBG
    set CFG1="passsync - Win64 Debug"
    set CFG2="passhook - Win64 Debug"
    set FLV=dbg
    set platdir=Debug_NonRedist\amd64
    set subdir=DebugCRT
    set suf=d
)
) else (
  set PLATFORM=i386
  set LDAPDATE=20091017.1
  set MSMPLAT=x86
if [%BUILD_DEBUG%] == [optimize] (
    set OPTDBG=_OPT
    set CFG1="passsync - Win32 Release"
    set CFG2="passhook - Win32 Release"
    set FLV=opt
    set platdir=x86
    set subdir=CRT
) else (
    set OPTDBG=_DBG
    set CFG1="passsync - Win32 Debug"
    set CFG2="passhook - Win32 Debug"
    set FLV=dbg
    set platdir=Debug_NonRedist\x86
    set subdir=DebugCRT
    set suf=d
)
)

set FLAVOR=WINNT%WINVER%%FLAG64%%OPTDBG%.OBJ

echo Build flavor is %FLAVOR%

REM Look for the merge module containing the redistributable
REM runtime for our platform

REM on 64-bit platforms
for %%i in ("%COMMONPROGRAMFILES(X86)%\Merge Modules\"Microsoft_*_CRT_*%MSMPLAT%.msm) do set CRTMSM="%%i"
for %%i in ("%COMMONPROGRAMFILES(X86)%\Merge Modules\"policy_*Microsoft_*_CRT_*%MSMPLAT%.msm) do set POLICYCRTMSM="%%i"

REM on 32-bit platforms
for %%i in ("%COMMONPROGRAMFILES%\Merge Modules\"Microsoft_*_CRT_*%MSMPLAT%.msm) do set CRTMSM="%%i"
for %%i in ("%COMMONPROGRAMFILES%\Merge Modules\"policy_*Microsoft_*_CRT_*%MSMPLAT%.msm) do set POLICYCRTMSM="%%i"

if not defined CRTMSM (
   if not ["%MSSDK%"] == [] (
      set CRTMSM="%MSSDK%"\Redist\VC\microsoft.vcxx.crt.%MSMPLAT%_msm.msm
      set POLICYCRTMSM="%MSSDK%"\Redist\VC\policy.x.xx.microsoft.vcxx.crt.%MSMPLAT%_msm.msm
   )
)

if not defined POLICYCRTMSM (
   if not ["%MSSDK%"] == [] (
      set POLICYCRTMSM="%MSSDK%"\Redist\VC\policy.x.xx.microsoft.vcxx.crt.%MSMPLAT%_msm.msm
   )
)

if not defined CRTMSM (
   echo ERROR: could not find the merge modules for the Visual C++
   echo runtime side by side assemblies - they should be provided
   echo with the Visual Studio C++ and/or the Windows SDK
   echo cannot continue
   exit 1
)

if not defined POLICYCRTMSM (
   echo ERROR 2: could not find the merge modules for the Visual C++
   echo runtime side by side assemblies - they should be provided
   echo with the Visual Studio C++ and/or the Windows SDK
   echo cannot continue
   exit 1
)

if ["%BRAND%"] == [""] (
   set BRAND=389
)
if ["%VENDOR%"] == [""] (
   set VENDOR=389 Project
)
if [%BRANDNOSPACE%] == [] (
   set BRANDNOSPACE=389
)
if [%VERSION%] == [] (
   set VERSION=1.1.4
)

rem ======== Set Various Build Directories ========
set OBJDEST=..\built\%FLAVOR%
rem   ------ Convert OBJEST to absolute ------
call :relative %OBJDEST% OBJDEST

set LIBROOT=..\components\%FLAVOR%
rem   ------ Convert LIBROOT to absolute ------
call :relative %LIBROOT% LIBROOT
mkdir "%LIBROOT%"

set PKGDIR=%OBJDEST%\package\passsync
mkdir "%PKGDIR%"

set DISTDIR=..\dist\%FLAVOR%
rem   ------ Convert DISTDIR to absolute ------
call :relative %DISTDIR% DISTDIR
mkdir "%DISTDIR%"

set WIXVER=3.7
set WIXDIR=C:\Program Files (x86)\WiX Toolset v%WIXVER%\bin

set WXSDIR=%CD%\wix

rem ======== Fetch Components ========
if [%INTERNAL_BUILD%] == [1] (
    set COMPONENT_URL=%SBC%
    set COMPONENT_URL2=%SBV%
) else (
    set COMPONENT_URL=http://port389.org/built/components
)

rem   ------ NSPR ------
set NSPR_LOCATION=%COMPONENT_URL%/nspr/v4.8.4
if NOT EXIST "%LIBROOT%\nspr" (
    echo on
    echo mkdir "%LIBROOT%\nspr"
    mkdir "%LIBROOT%\nspr"
    echo mkdir "%LIBROOT%\nspr\include"
    mkdir "%LIBROOT%\nspr\include"
    echo pushd "%LIBROOT%\nspr"
    pushd "%LIBROOT%\nspr"
    echo %NSPR_LOCATION%/%FLAVOR% > version.txt
    echo %DOWNLOAD% %NSPR_LOCATION%/%FLAVOR%/mdbinary.jar "%LIBROOT%\nspr\mdbinary.jar"
    %DOWNLOAD% %NSPR_LOCATION%/%FLAVOR%/mdbinary.jar "%LIBROOT%\nspr\mdbinary.jar"
    echo %DOWNLOAD% %NSPR_LOCATION%/%FLAVOR%/mdheader.jar "%LIBROOT%\nspr\mdheader.jar"
    %DOWNLOAD% %NSPR_LOCATION%/%FLAVOR%/mdheader.jar "%LIBROOT%\nspr\mdheader.jar"
    echo %UZCMD% mdbinary.jar
    %UZCMD% mdbinary.jar
    echo cd include
    cd include
    echo %UZCMD% ..\mdheader.jar
    %UZCMD% ..\mdheader.jar
    echo popd
    popd
    echo off
)

rem   ------ NSS ------
set NSS_LOCATION=%COMPONENT_URL%/nss/NSS_3_12_6_RTM
if NOT EXIST "%LIBROOT%\nss" (
    mkdir "%LIBROOT%\nss"
    mkdir "%LIBROOT%\nss\include"
    pushd "%LIBROOT%\nss"
    echo %NSS_LOCATION%/%FLAVOR% > version.txt
    %DOWNLOAD% %NSS_LOCATION%/%FLAVOR%/mdbinary.jar "%LIBROOT%\nss\mdbinary.jar"
    %DOWNLOAD% %NSS_LOCATION%/%FLAVOR%/include/xpheader.jar "%LIBROOT%\nss\xpheader.jar"
    %UZCMD% mdbinary.jar
    cd include
    %UZCMD% ..\xpheader.jar
    popd
)

rem   ------ LDAPSDK ------
set LDAPSDK_LOCATION=%COMPONENT_URL2%/ldapcsdk/v6.0.6/%LDAPDATE%
if NOT EXIST "%LIBROOT%\ldapsdk" (
    mkdir "%LIBROOT%\ldapsdk"
    pushd "%LIBROOT%\ldapsdk"
    echo %LDAPSDK_LOCATION%/%FLAVOR% > version.txt
    %DOWNLOAD% %LDAPSDK_LOCATION%/%FLAVOR%/mozldap_%FLV%.zip "%LIBROOT%\ldapsdk\mozldap_%FLV%.zip"
    %UZCMD% mozldap_%FLV%.zip
    popd
)

rem   ------ WIX ------
set WIX_LOCATION=%COMPONENT_URL%/wix
if NOT EXIST "%WIXDIR%" (
    mkdir "%WIXDIR%"
    pushd "%WIXDIR%"
    echo %WIX_LOCATION% > version.txt
    %DOWNLOAD% %WIX_LOCATION%/wix-%WIXVER%.zip "%WIXDIR%\wix-%WIXVER%.zip"
    %UZCMD% wix-%WIXVER%.zip
    popd
)

set OK=0

pushd "%CD%"

rem ======== Build ========
rem   ------ Set Build Paths ------
set INCLUDE=%INCLUDE%;%LIBROOT%\ldapsdk\public\ldap;%LIBROOT%\nspr\include;%LIBROOT%\nss\include
set LIB=%LIB%;%LIBROOT%\ldapsdk\lib;%LIBROOT%\nspr\lib;%LIBROOT%\nss\lib

rem   ------ PassSync ------
cd passsync
echo -------- Beginning PassSync Build --------

rem nmake CFG=%CFG1% /nologo /d /p /g /f passsync.mak
rem /d /p /g are debugging flags
rem /nologo is the shut up flag
nmake CFG=%CFG1% /nologo /f passsync.mak
set /a OK=%OK% + %ERRORLEVEL%

if [%OK%] GTR [1] (
    echo -------- PassSync Build Failed! --------
    goto :END
) else (
    echo -------- PassSync Build Successful! --------
)

rem   ------ Passhook ------
cd ..\passhook
echo -------- Beginning Passhook Build --------

nmake /nologo CFG=%CFG2% /f passhook.mak
set /a OK=%OK% + %ERRORLEVEL%

if [%OK%] GTR [1] (
    echo -------- Passhook Build Failed! --------
    goto :END
) else (
    echo -------- Passhook Build Successful! --------
)

rem ======== Package ========
cd ..
echo -------- Beginning Packaging --------

nmake /nologo CFG=%CFG1% USE64=%USE64% PLATFORM=%PLATFORM% "BRAND=%BRAND%" BRANDNOSPACE=%BRANDNOSPACE%  "VENDOR=%VENDOR%" CRTMSM=%CRTMSM% POLICYCRTMSM=%POLICYCRTMSM% VERSION=%VERSION% /f package.mak
set /a OK=%OK% + %ERRORLEVEL%

set PKGNAME=%BRANDNOSPACE%-PassSync-%VERSION%-%PLATFORM%.msi

if EXIST "%PKGDIR%\%PKGNAME%" (
    copy /Y "%PKGDIR%\%PKGNAME%" "%DISTDIR%"
    set /a OK=%OK% + %ERRORLEVEL%
)

if [%OK%] GTR [1] (
    echo -------- Packaging Failed! --------
    goto :END
) else (
    echo -------- Packaging Successful! --------
)

:END
popd
if [%OK%] GTR [1] (
    echo -------- Build Failed! --------
    set OK=1
) else (
    echo -------- Build Successful! --------
)
exit %OK%

:relative
rem ======== Converts relative path to absolute path ========
rem   ------ %1 is the path, %2 is the variable to be set ------
set %2=%~f1
goto :EOF
