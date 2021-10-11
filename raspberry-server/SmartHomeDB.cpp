/*
    SmartHomeDB.cpp
*/

#include "SmartHomeDB.h"

#define DEBUG 1
#define QUERY_VIEW 1

void DBManager::insert(const string tb_name, const string data1, const string data2)
{
    TBType type = getType(tb_name);

    if (type == TB_NONE)
    {
#if DEBUG
        cout << tb_name << " is not exists type.." << endl;
#endif
        return;
    }

    string msg = "INSERT INTO ";

    msg.append(tb_name);

    switch (type)
    {
    case TBType::TB_USER:
        msg.append("(UserID, UserPW) ");
        break;

    case TBType::TB_TEMP:
    case TBType::TB_HUMI:
    case TBType::TB_AIRQ:
        msg.append("(Date, Value) ");
        break;

    default:
        return;
    }

    msg.append("VALUES('")
        .append(data1)
        .append("', '")
        .append(data2)
        .append("')");

    query(msg);
}

void DBManager::search(const string tb_name, const string condition)
{
    string msg = "SELECT * FROM ";
    msg.append(tb_name).append(" ").append(condition);
    query(msg);
}

bool DBManager::accountCheck(const string id, const string pw)
{
    string condition = "WHERE UserID LIKE '";
    condition.append(id).append("' AND UserPW LIKE '").append(pw).append("'");
    search(TBUSER, condition);
    MYSQL_RES *result = mysql_store_result(connection);
    if (result == NULL)
        queryError();

    int num_rows = mysql_num_rows(result);

    mysql_free_result(result);

    if (num_rows <= 0)
        return false;

    return true;
}

void DBManager::accountDelete(const string userId)
{
    string msg = "DELETE FROM ";
    msg.append(TBUSER)
        .append(" WHERE UserID='")
        .append(userId)
        .append("'");
    query(msg);
}

void DBManager::init()
{
// version check
#if DEBUG
    cout << "MySQL Client version : " << mysql_get_client_info() << endl;
#endif

    connectionInit();
    createDB();
    createTB();

    // indexs = new int[TYPENUM]{
    //     initIndex(TBUSER),
    //     initIndex(TBTEMP),
    //     initIndex(TBHUMI),
    //     initIndex(TBAIRQ)};
}

int DBManager::initIndex(const string tb_name)
{
    search(tb_name);
    MYSQL_RES *result = mysql_store_result(connection);
    if (result == NULL)
        queryError();

    int numFields = mysql_num_rows(result);

    mysql_free_result(result);

    return numFields;
}

void DBManager::release()
{
    if (connection != NULL)
        mysql_close(connection);

    connection = NULL;

// MYSQL release
#if DEBUG
    cout << "## db manager released." << endl;
#endif
}

void DBManager::connectionInit()
{
    // MYSQL structure initialize.
    // this function allocates memory.
    // if result is NOT null.
    // must call the mysql_close() function. when application exit
    connection = mysql_init(NULL);
    if (connection == NULL)
    {
#if DEBUG
        cout << "## mysql_init : " << mysql_error(connection) << endl;
#endif
        exit(INIT_CONNECT);
    }

    reconnect = 0;
    if (mysql_options(connection, MYSQL_OPT_RECONNECT, &reconnect))
    {
        queryError();
    }

    // try real connect
    if (mysql_real_connect(connection, HOSTID, USERID, PASSWD, NULL, 3306, NULL, 0) == NULL)
    {
#if DEBUG
        cout << "## mysql_real_connect : " << mysql_error(connection) << endl;
#endif
        mysql_close(connection);
        exit(INIT_REAL_CONNECT);
    }

#if DEBUG
    cout << "## success mysql connected." << endl;
#endif
}

void DBManager::createDB()
{
    string msg = "CREATE DATABASE IF NOT EXISTS ";
    msg.append(DBNAME);
    query(msg);

    if (mysql_select_db(connection, DBNAME))
    {
#if DEBUG
        cout << DBNAME << " created successfully" << endl;
#endif
    }
    else
    {
#if DEBUG
        cout << DBNAME << " something wrong.." << endl;
#endif
        queryError();
    }
}

void DBManager::createTB()
{
    string msg = "CREATE TABLE IF NOT EXISTS ";
    msg.append(TBUSER).append("(ID INT PRIMARY KEY AUTO_INCREMENT, UserID VARCHAR(10) UNIQUE, UserPW TEXT)");
    query(msg);

    msg = "CREATE TABLE IF NOT EXISTS ";
    msg.append(TBTEMP).append("(ID INT PRIMARY KEY AUTO_INCREMENT, Date TEXT, Value TEXT)");
    query(msg);

    msg = "CREATE TABLE IF NOT EXISTS ";
    msg.append(TBHUMI).append("(ID INT PRIMARY KEY AUTO_INCREMENT, Date TEXT, Value TEXT)");
    query(msg);

    msg = "CREATE TABLE IF NOT EXISTS ";
    msg.append(TBAIRQ).append("(ID INT PRIMARY KEY AUTO_INCREMENT, Date TEXT, Value TEXT)");
    query(msg);

#if DEBUG
    cout << "tables created successfully" << endl;
#endif
}

void DBManager::query(const string msg)
{
    // db server connect check
    if (mysql_ping(connection) != 0)
        queryError();

#if QUERY_VIEW
    cout << "[" << DBNAME << "]> " << msg << endl;
#endif
    int status = mysql_query(connection, msg.c_str());
    if (status != 0)
        queryError();
}

bool DBManager::queryError()
{
    const char *error_str = mysql_error(connection);
    unsigned int error_num = mysql_errno(connection);

    if (error_str[0])
    {
#if DEBUG
        cout << "## [" << error_num << "] mysql_query error: " << error_str << endl;
#endif
        // unique, primary key error
        if (error_num == 1062)
            return true;

        mysql_close(connection);
        exit(QUERY_ERROR);
    }

    return false;
}

TBType DBManager::getType(const string tb_name)
{
    if (tb_name == TBUSER)
        return TB_USER;
    else if (tb_name == TBTEMP)
        return TB_TEMP;
    else if (tb_name == TBHUMI)
        return TB_HUMI;
    else if (tb_name == TBAIRQ)
        return TB_AIRQ;
    else
        return TB_NONE;
}

DBManager::DBManager()
{
    init();
}

DBManager::~DBManager()
{
    release();
}
