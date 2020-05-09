/*
 * util.c - commonly used utility functions.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "util.h"

/* ��鲢���䳤��Ϊlen���ڴ�ռ䣬Ȼ�󷵻�����ڴ�ռ��ָ�� */
void *checked_malloc(int len){
	void *p = malloc(len);
 	if (!p) {
    fprintf(stderr,"\nRan out of memory!\n");
    exit(1);
 	}
 	return p;
}

/* ����s���¿���һ�ݲ����ء����صĴ������Լ����ڴ�ռ䡣*/
string String(char *s){
	string p = checked_malloc(strlen(s)+1);
 	strcpy(p,s);
 	return p;
}
