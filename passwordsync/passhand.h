/* --- BEGIN COPYRIGHT BLOCK ---
 * This Program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; version 2 of the License.
 * 
 * This Program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along with
 * this Program; if not, write to the Free Software Foundation, Inc., 59 Temple
 * Place, Suite 330, Boston, MA 02111-1307 USA.
 * 
 * In addition, as a special exception, Red Hat, Inc. gives You the additional
 * right to link the code of this Program with code not covered under the GNU
 * General Public License ("Non-GPL Code") and to distribute linked combinations
 * including the two, subject to the limitations in this paragraph. Non-GPL Code
 * permitted under this exception must only link to the code of this Program
 * through those well defined interfaces identified in the file named EXCEPTION
 * found in the source code files (the "Approved Interfaces"). The files of
 * Non-GPL Code may instantiate templates or use macros or inline functions from
 * the Approved Interfaces without causing the resulting work to be covered by
 * the GNU General Public License. Only Red Hat, Inc. may make changes or
 * additions to the list of Approved Interfaces. You must obey the GNU General
 * Public License in all respects for all of the Program code and other code used
 * in conjunction with the Program except the Non-GPL Code covered by this
 * exception. If you modify this file, you may extend this exception to your
 * version of the file, but you are not obligated to do so. If you do not wish to
 * provide this exception without modification, you must delete this exception
 * statement from your version and license this file solely under the GPL without
 * exception. 
 * 
 * 
 * Copyright (C) 2005 Red Hat, Inc.
 * All rights reserved.
 * --- END COPYRIGHT BLOCK --- */

// Created: 2-8-2005
// Author(s): Scott Bridges
#ifndef _PASSHAND_H_
#define _PASSHAND_H_

#include <windows.h>
#include <time.h>
#include <errno.h>
#include <stdlib.h>
#include <strstream>
#include <fstream>
#include <list>
#include "nss.h"
#include "pk11func.h"
#include "prerror.h"

#define PASSHAND_EVENT_NAME "passhandunl_event"
#define PASSHOOK_MUTEX_NAME "passhookunl_mutex"

#define PASSHOOK_TIMEOUT 30000
#define PASSHAND_BUF_SIZE 256

using namespace std;

struct PASS_INFO
{
	char* username;
	char* password;
	int backoffCount;
	time_t atTime;
};

typedef list<PASS_INFO> PASS_INFO_LIST;
typedef list<PASS_INFO>::iterator PASS_INFO_LIST_ITERATOR;

void timeStamp(fstream* outFile);
void wtimeStamp(wfstream* outFile);

int encrypt(char* plainTextBuf, int plainTextLen, char* cipherTextBuf, int cipherTextLen, int* resultTextLen);
int decrypt(char* cipherTextBuf, int cipherTextLen, char* plainTextBuf, int plainTextLen, int* resultTextLen);

int saveSet(PASS_INFO_LIST* passInfoList, char* filename);
int loadSet(PASS_INFO_LIST* passInfoList, char* filename);
int clearSet(PASS_INFO_LIST* passInfoList);

#endif
