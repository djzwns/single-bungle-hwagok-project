/*
    SmartHomeDB.h

    smarthome_db
        - tb_useraccount
            id:char, passwd:char
        - tb_tempurature
            time:char, temp:char
        - tb_humidity
            time:char, humi:char
        - tb_airquality
            time:char, air:char
*/
#ifndef _SMARTHOME_DB_
#define _SMARTHOME_DB_

#include <mysql.h>
#include <iostream>
#include <cassert>
#include <string>

using namespace std;

#define HOSTID "localhost"
#define USERID "pi"
#define PASSWD "raspberry"
#define DBNAME "smarthome_db"
#define TBUSER "tb_useraccount"
#define TBTEMP "tb_tempurature"
#define TBHUMI "tb_humidity"
#define TBAIRQ "tb_airquality"

#define TYPENUM 4

enum ExitType
{
    INIT_CONNECT = 1,
    INIT_REAL_CONNECT,
    QUERY_ERROR,
};

enum TBType
{
    TB_USER,
    TB_TEMP,
    TB_HUMI,
    TB_AIRQ,
    TB_NONE
};

class DBManager
{
public:
    DBManager();
    ~DBManager();

    void insert(const string tb_name, const string data1, const string data2);

    bool accountCheck(const string id, const string pw);
    void accountDelete(const string userId);

private:
    void init();
    void release();

    int initIndex(const string tb_name);
    void connectionInit();
    void createDB();
    void createTB();

    void query(const string msg);
    void search(const string tb_name, const string condition = "");

    TBType getType(const string tb_name);

    bool queryError();

private:
    my_bool reconnect;
    MYSQL *connection;
};

#endif //_SMARTHOME_DB_