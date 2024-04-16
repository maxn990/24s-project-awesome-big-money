from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

events = Blueprint('events', __name__)

#######################################################
## PRACTICE ATTENDANCE ROUTES
#######################################################

@events.route('/practiceAttendance/<player_id>', methods=['GET'])
def get_practice_attendance(player_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM PracticeAttendance '
                   'WHERE player_id = "{}"'.format(player_id))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@events.route('/practiceAttendance/<practice_id>/<player_id>', methods=['POST'])
def add_practice_attendance(practice_id, player_id):
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    # Constructing the query
    query = (
    'INSERT INTO Coaches (practice_id, player_id) '
    'VALUES ("{}", "{}")'
    ).format(practice_id, player_id)
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'

#######################################################
## GAME COACHES ROUTES
#######################################################

@events.route('/gameCoaches/<coach_id>', methods=['GET'])
def get_player_profile_coach(coach_id, game_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM gameCoaches WHERE coach_id = {}'.format
                   (coach_id, game_id))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@events.route('/gameCoaches/<coach_id>/<game_id>', methods=['POST'])
def add_player_information_coach(coach_id, game_id):
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    # Constructing the query
    query = 'insert into GameCoaches (coach_id, game_id) values ("'
    query += str(coach_id) + '", "'
    query += str(game_id) + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'

#######################################################
## GAMES ROUTES
#######################################################

@events.route('/Games', methods=['GET'])
def get_league():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Games')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@events.route('/Games', methods=['POST'])
def add_new_league():
    
    # collecting data from the request object
    the_data = request.json
    current_app.logger.info(the_data)

    # extracting the variable
    date = the_data['date']
    winner_id = the_data['winner_id']
    time = the_data['time']
    referee = the_data['referee']
    state = the_data['state']
    city = the_data['city']
    park = the_data['park']

    # Constructing the query
    query = 'insert into Leagues (date, winner_id, time, referee, state, city, park) values ("'
    query += date + '", "'
    query += winner_id + '", "'
    query += time + '", '
    query += referee + '", '
    uery += state + '", '
    uery += city + '", '
    query += park + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'


 #######################################################
## PRACTICES ROUTES
#######################################################

@events.route('/Practices', methods=['GET'])
def get_practices():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Practices')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@events.route('/Practices', methods=['POST'])
def add_new_league():
    
    # collecting data from the request object
    the_data = request.json
    current_app.logger.info(the_data)

    # extracting the variable
    date = the_data['time']
    time = the_data['date']
    state = the_data['state']
    city = the_data['city']
    park = the_data['park']

    # Constructing the query
    query = 'insert into Leagues (time, date, state, city, park) values ("'
    query += time + '", "'
    query += date + '", '
    uery += state + '", '
    uery += city + '", '
    query += park + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'