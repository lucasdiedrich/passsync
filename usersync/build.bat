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

if [%BUILD_DEBUG%] == [optimize] (
    set FLAVOR=WINNT5.0_OPT.OBJ
) else (
    set FLAVOR=WINNT5.0_DBG.OBJ
)

rem ======== Set Various Build Directories ========
set OBJDEST=..\built\%FLAVOR%
rem   ------ Convert OBJEST to absolute ------
call :relative %OBJDEST% OBJDEST

set LIBROOT=..\components\%FLAVOR%
rem   ------ Convert LIBROOT to absolute ------
call :relative %LIBROOT% LIBROOT
mkdir %LIBROOT%

set PKGDIR=%OBJDEST%\package\ntds
mkdir %PKGDIR%

set DISTDIR=..\dist\%FLAVOR%
rem   ------ Convert DISTDIR to absolute ------
call :relative %DISTDIR% DISTDIR
mkdir %DISTDIR%

set WXSDIR=%CD%\wix

rem ======== Fetch Components ========
if [%INTERNAL_BUILD%] == [1] (
    set COMPONENT_URL=http://ftp-rel.sfbay.redhat.com/share/builds/components
) else (
    set COMPONENT_URL=http://port389.org/built/components
)

rem   ------ ApacheDS ------
set APACHEDS_LOCATION=%COMPONENT_URL%/apacheds/0.9
set APACHEDSSOURCE=%OBJDEST%\apacheds\apacheds-0.9
set APACHEDS_FILE=%LIBROOT%\apacheds\apacheds-main-0.9.jar
if NOT EXIST %LIBROOT%\apacheds (
    pushd %CD%
    mkdir %LIBROOT%\apacheds
    cd %LIBROOT%\apacheds
    echo %APACHEDS_LOCATION% > version.txt
    wget --no-directories %APACHEDS_LOCATION%/apacheds-0.9-src.zip
    unzip -q -d%OBJDEST%\apacheds apacheds-0.9-src.zip
    wget --no-directories %APACHEDS_LOCATION%/apacheds-main-0.9.jar
    popd
)

rem   ------ Wrapper ------
set WRAPPER_LOCATION=%COMPONENT_URL%/wrapper/3.1.2
set WRAPPER_FILES=%LIBROOT%\wrapper\wrapper_win32_3.1.2
if NOT EXIST %LIBROOT%\wrapper (
    pushd %CD%
    mkdir %LIBROOT%\wrapper
    cd %LIBROOT%\wrapper
    echo %WRAPPER_LOCATION% > version.txt
    wget --no-directories %WRAPPER_LOCATION%/wrapper_win32_3.1.2.zip
    unzip -q wrapper_win32_3.1.2.zip
    popd
)

set OK=0

pushd %CD%

rem ======== Build ========
rem   ------ Netman ------
cd netman
echo -------- Beginning Netman Build --------

nmake /f netman.mak
set /a OK=%OK% + %ERRORLEVEL%

if [%OK%] GTR [1] (
    echo -------- Netman Build Failed! --------
    goto :END
) else (
    echo -------- Netman Build Successful! --------
)

rem   ------ ApacheDS ------
cd ..\apacheds
echo -------- Beginning ApacheDS Build --------

nmake /f apacheds.mak
set /a OK=%OK% + %ERRORLEVEL%

if [%OK%] GTR [1] (
    echo -------- ApacheDS Build Failed! --------
    goto :END
) else (
    echo -------- ApacheDS Build Successful! --------
)

rem ======== Package ========
cd ..
echo -------- Beginning Packaging --------

nmake /f package.mak
set /a OK=%OK% + %ERRORLEVEL%

if EXIST %PKGDIR%\ntds.msi (
    copy /Y %PKGDIR%\ntds.msi %DISTDIR%
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
