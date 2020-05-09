/* ��������﷨�����������������ݽṹ */

#include "util.h"

typedef int a_pos; //a_posΪԴ�ļ�ĳ�Ǻŵ�λ�����ͣ������á�

typedef struct a_exp_ * a_exp;
typedef struct a_bexp_ * a_bexp;
typedef struct a_id_ * a_id;
typedef struct a_stm_ * a_stm;
typedef struct a_stm_list_ * a_stm_list;
typedef struct a_dec_ * a_dec;
typedef struct a_dec_list_ * a_dec_list;
typedef struct a_var_list_ * a_var_list;
typedef struct a_prog_ * a_prog;

/* ��������������T_int��ʵ��T_real���� */
typedef enum{T_int, T_real} ttype;

/* ��Ԫ�������������֣�+ - * / */
typedef enum {A_plusOp, A_minusOp, A_timesOp, A_divideOp} a_op;

/* ��Ԫ�����������֣�=, <>, <, <=, >, >= */
typedef enum {A_eqOp, A_neqOp, A_ltOp, A_leOp, A_gtOp, A_geOp} a_bop;


/* id�����ݽṹ��posΪλ�ã�valΪid������ */
struct a_id_ {
  a_pos pos;
  string val;
};

/* �������ʽ���ݽṹ��
 * kindΪ���ʽ�����ͣ���Ϊ��������������ʵ�����Ͷ�Ԫ���ʽ
 */
struct a_exp_ {
  enum {A_varExp, A_intExp, A_realExp, A_opExp} kind;
  a_pos pos;
  union {
    struct {
      a_op op;
      a_exp left;
      a_exp right;
    }biopExp; //��Ԫ������ʽ��left op right
    a_id var; //�������ʽ
    int ival; //���������ʽ
    double fval;//ʵ�������ʽ
  }exp;
};

/* �������ʽ���ݽṹ */
struct a_bexp_{
	a_pos pos;
	struct {
    a_bop bop;
    a_exp left;
    a_exp right;
  } bexp;
};

/* ������ݽṹ��
 * ���ͷ�Ϊ��ֵ��䡢if��䡢while��䡢˳����䣨������У� 
 */
struct a_stm_ {
  enum {A_assign, A_if, A_while, A_seq} kind;
  a_pos pos;
  union {
    struct a_assign_stm_ {
      a_id var;
      a_exp exp;
    } assign;//��ֵ��䣺var = exp;
    struct a_if_stm_ {
      a_bexp b;
      a_stm s1;
      a_stm s2;
    } iff;// if��䣺if b then s1 else s2;
    struct a_while_stm_ {
      a_bexp b;
      a_stm s;
    } whilee;// while��䣺while b do s;
    a_stm_list seq;//˳����䣺������˳�������һ���б�
  } stm;
};

/* ����б����ݽṹ */
struct a_stm_list_ {
  a_stm head;
  a_stm_list tail;
};

/* �����б����ݽṹ */
struct a_var_list_ {
  a_id head;
  a_var_list tail;
};

/* �����������ݽṹ ��
 * ��������Ϊtype�������б�Ϊvarlist��
 * ��������var a, b, c : INTEGER;
 *     ����a,b,c���varlist��typeΪT_int����ʾINTEGER����
 */
struct a_dec_ {
  ttype type;
  a_pos pos;
  a_var_list varlist;
};

/* ���������б����ݽṹ */
struct a_dec_list_ {
  a_dec head;
  a_dec_list tail;
};

/* �������ݽṹ��
 * nameΪ��������declistΪ������������б� */
struct a_prog_ {
  char * name;
  a_pos pos;
  a_dec_list declist;
  a_stm_list stmlist;
};

/* ����ĺ����Ǹ����﷨�ṹ�Ĺ��캯�� */
a_id A_Id(a_pos pos, string val);
a_exp A_IntExp(a_pos pos, int ival);
a_exp A_RealExp(a_pos pos, double fval);
a_exp A_VarExp(a_pos pos, a_id var);
a_exp A_OpExp(a_pos pos, a_op op, a_exp left, a_exp right);
a_bexp A_BExp(a_pos pos, a_bop bop, a_exp left, a_exp right);
a_stm A_Assign (a_pos pos, a_id var, a_exp exp);
a_stm A_If(a_pos pos, a_bexp b, a_stm s1, a_stm s2);
a_stm A_While(a_pos pos, a_bexp b, a_stm s);
a_stm A_Seq(a_pos pos, a_stm_list sl);
a_stm_list A_StmList(a_stm s, a_stm_list sl);
a_var_list A_VarList(a_id v, a_var_list vl);
a_dec A_VarDec(a_pos pos, a_var_list vl, ttype t);
a_dec_list A_DecList(a_dec vd, a_dec_list vdl);
a_prog A_Prog (a_pos pos, char * name, a_dec_list dl, a_stm_list sl);

