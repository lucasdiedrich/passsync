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

rem set DOWNLOAD=echo DOWNLOAD
set DOWNLOAD="c:\program files\support tools\bitsadmin" /wrap /transfer passsyncbuild /download /priority normal
set UNZIP=cscript //nologo "%CD%\unzip.vbs"
@rem set DOWNLOAD=wget --no-directories
@rem set UNZIP=unzip -q

if [%BUILD_DEBUG%] == [optimize] (
    set FLAVOR=WINNT5.0_OPT.OBJ
    set CFG1="passsync - Win32 Release"
    set CFG2="passhook - Win32 Release"
) else (
    set FLAVOR=WINNT5.0_DBG.OBJ
    set CFG1="passsync - Win32 Debug"
    set CFG2="passhook - Win32 Debug"
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

set WIXVER=2.0.5805.0
set WIXDIR=..\wix
rem   ------ Convert WIXDIR to absolute ------
call :relative %WIXDIR% WIXDIR

set WXSDIR=%CD%\wix

rem ======== Fetch Components ========
if [%INTERNAL_BUILD%] == [1] (
    set COMPONENT_URL=%SBC%
    set COMPONENT_URL2=%SBV%
) else (
    set COMPONENT_URL=http://port389.org/built/components
)

rem   ------ NSPR ------
set NSPR_LOCATION=%COMPONENT_URL%/nspr/v4.7.3
if NOT EXIST "%LIBROOT%\nspr" (
    mkdir "%LIBROOT%\nspr"
    mkdir "%LIBROOT%\nspr\include"
    pushd "%LIBROOT%\nspr"
    echo %NSPR_LOCATION%/%FLAVOR% > version.txt
    %DOWNLOAD% %NSPR_LOCATION%/%FLAVOR%/mdbinary.jar "%LIBROOT%\nspr\mdbinary.jar"
    %DOWNLOAD% %NSPR_LOCATION%/%FLAVOR%/mdheader.jar "%LIBROOT%\nspr\mdheader.jar"
    %UNZIP% mdbinary.jar
    cd include
    %UNZIP% ..\mdheader.jar
    popd
)

rem   ------ NSS ------
set NSS_LOCATION=%COMPONENT_URL%/nss/NSS_3_12_2_RTM
if NOT EXIST "%LIBROOT%\nss" (
    mkdir "%LIBROOT%\nss"
    mkdir "%LIBROOT%\nss\include"
    pushd "%LIBROOT%\nss"
    echo %NSS_LOCATION%/%FLAVOR% > version.txt
    %DOWNLOAD% %NSS_LOCATION%/%FLAVOR%/mdbinary.jar "%LIBROOT%\nss\mdbinary.jar"
    %DOWNLOAD% %NSS_LOCATION%/include/xpheader.jar "%LIBROOT%\nss\xpheader.jar"
    %UNZIP% mdbinary.jar
    cd include
    %UNZIP% ..\xpheader.jar
    popd
)

rem   ------ LDAPSDK ------
set LDAPSDK_LOCATION=%COMPONENT_URL2%/ldapcsdk/v6.0.5/20090128.1
if NOT EXIST "%LIBROOT%\ldapsdk" (
    mkdir "%LIBROOT%\ldapsdk"
    pushd "%LIBROOT%\ldapsdk"
    echo %LDAPSDK_LOCATION%/%FLAVOR% > version.txt
    %DOWNLOAD% %LDAPSDK_LOCATION%/%FLAVOR%/ldapcsdk.zip "%LIBROOT%\ldapsdk\ldapcsdk.zip"
    %UNZIP% ldapcsdk.zip
    popd
)

rem   ------ WIX ------
set WIX_LOCATION=%COMPONENT_URL%/wix
if NOT EXIST "%WIXDIR%" (
    mkdir "%WIXDIR%"
    pushd "%WIXDIR%"
    echo %WIX_LOCATION% > version.txt
    %DOWNLOAD% %WIX_LOCATION%/wix-%WIXVER%.zip "%WIXDIR%\wix-%WIXVER%.zip"
    %UNZIP% wix-%WIXVER%.zip
    popd
)

set OK=0

pushd "%CD%"

rem ======== Build ========
rem   ------ Set Build Paths ------
set INCLUDE=%INCLUDE%;%LIBROOT%\ldapsdk\include;%LIBROOT%\nspr\include;%LIBROOT%\nss\include
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

nmake /nologo CFG=%CFG1% /f package.mak
set /a OK=%OK% + %ERRORLEVEL%

if EXIST "%PKGDIR%\PassSync.msi" (
    copy /Y "%PKGDIR%\PassSync.msi" "%DISTDIR%"
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
