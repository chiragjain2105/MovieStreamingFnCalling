import mysql.connector

def get_db_cursor():
    db = mysql.connector.connect(host='localhost', database='moviestremingdb', user='root', password='1234')
    cursor = db.cursor()
    return db, cursor


def close_db_connection(db, cursor):
    cursor.close()
    db.close()


def get_movie_info(params):
    db, cursor = get_db_cursor()
    cursor.callproc('GetStreamingData', [params.get('date'), params.get('movie'), params.get('director'),
                                         params.get('operation')])
    result = None
    for res in cursor.stored_results():
        result = float(res.fetchone()[0])
    close_db_connection(db, cursor)
    # print(result)
    return result


if __name__ == '__main__':
    print(get_movie_info({
        'date': '2022-04-02',
        'operation': 'AVG'
    }))
