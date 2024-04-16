from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

events = Blueprint('events', __name__)

#######################################################
## PRACTICE ATTENDANCE ROUTES
#######################################################

@events.route('/practiceAttendance', methods=['GET'])
def get_practice_attendance():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM PracticeAttendance pa '
                    'JOIN Practices p ON pa.practice_id = p.practice_id '
                    ' JOIN Players pl ON pa.player_id = pl.player_id;')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    data = cursor.fetchall()
    for row in data:
        row_dict = dict(zip(row_headers, row))
        row_dict['time'] = str(row_dict['time'])
        json_data.append(row_dict)
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

@events.route('/practiceAttendance/<player_id>', methods=['GET'])
def get_practice_attendance_player(player_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM PracticeAttendance '
                   'WHERE player_id = "{}"'.format(player_id))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    data = cursor.fetchall()
    for row in data:
        json_data.append(dict(zip(row_headers, row)))
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

@events.route('/practiceAttendance', methods=['POST'])
def add_practice_attendance():
    # Collecting data from the request object 
    data = request.json
    current_app.logger.info(data)

    # Extracting the varaibles
    practice_id = data['practice_id']
    player_id = data['player_id']

    # Constructing the query
    query = (
    'INSERT INTO Coaches (practice_id, player_id) '
    'VALUES ("{}", "{}")'
    ).format(practice_id, player_id)
    current_app.logger.info(query)

    # Executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'

@events.route('/practiceAttendance', methods=['DELETE'])
def remove_practice_attendance():
    # Collecting data from the request object
    data = request.json
    current_app.logger.info(data)

    # Extracting the varaibles
    practice_id = data['practice_id']
    player_id = data['player_id']

    # Constructing the query
    query = ('DELETE FROM PracticeAttendance WHERE player_id = {} '
             'AND practice_id = {}').format(player_id, practice_id)
    current_app.logger.info(query)
    
    # Executing and committing the delete statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Practice Attendance deleted successfully'

#######################################################
## PRACTICE ATTENDANCE ROUTES
#######################################################

@events.route('/gameAttendance', methods=['GET'])
def get_game_attendance():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM GameAttendance ga '
                    'JOIN Games g ON ga.game_id = g.game_id '
                    'JOIN Players pl ON ga.player_id = pl.player_id;')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    data = cursor.fetchall()
    for row in data:
        row_dict = dict(zip(row_headers, row))
        row_dict['time'] = str(row_dict['time'])
        json_data.append(row_dict)
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

@events.route('/gameAttendance', methods=['DELETE'])
def delete_game_attendance():
    # Collecting data from the request object
    data = request.json
    current_app.logger.info(data)

    # Extracting the varaibles
    game_id = data['game_id']
    player_id = data['player_id']

    # Constructing the query
    query = ('DELETE FROM GameAttendance WHERE player_id = {} '
             'AND game_id = {}').format(player_id, game_id)
    current_app.logger.info(query)
    
    # Executing and committing the delete statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Game Attendance deleted successfully'


#######################################################
## GAME COACHES ROUTES
#######################################################

@events.route('/gameCoaches/<coach_id>', methods=['GET'])
def get_game_coaches(coach_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM GameCoaches WHERE coach_id = {}'.format
                   (coach_id))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    data = cursor.fetchall()
    for row in data:
        json_data.append(dict(zip(row_headers, row)))
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

@events.route('/gameCoaches', methods=['POST'])
def add_game_coaches():
    # Collecting data from the request object 
    data = request.json
    current_app.logger.info(data)

    # Extracting the varaibles
    coach_id = data['coach_id']
    game_id = data['game_id']

    # Constructing the query
    query = (
    'INSERT INTO GameCoaches (coach_id, game_id) '
    'VALUES ("{}", "{}")'
    ).format(coach_id, game_id)
    current_app.logger.info(query)

    # Executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'

#######################################################
## GAMES ROUTES 
#######################################################

@events.route('/games', methods=['GET'])
def get_games():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Games')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    data = cursor.fetchall()
    for row in data:
        row_dict = dict(zip(row_headers, row))
        row_dict['time'] = str(row_dict['time'])
        json_data.append(row_dict)
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

@events.route('/games', methods=['POST'])
def add_games():
    # Collecting data from the request object
    data = request.json
    current_app.logger.info(data)

    # Extracting the variable
    date = data['date']
    winner_id = data['winner_id']
    loser_id = data['loser_id']
    time = data['time']
    referee = data['referee']
    state = data['state']
    city = data['city']
    park = data['park']

    # Constructing the query
    query = (
    'INSERT INTO Games (date, winner_id, loser_id, time, referee, state, city, park) '
    'VALUES ("{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}")'
    ).format(date, winner_id, loser_id, time, referee, state, city, park)
    current_app.logger.info(query)

    # Executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'


 #######################################################
## PRACTICES ROUTES
#######################################################

@events.route('/practices', methods=['GET'])
def get_practices():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Practices')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    data = cursor.fetchall()
    for row in data:
        row_dict = dict(zip(row_headers, row))
        row_dict['time'] = str(row_dict['time'])
        json_data.append(row_dict)
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

@events.route('/practices/<practice_id>', methods=['GET'])
def get_practices_id(practice_id):
    cursor = db.get_db().cursor()
    cursor.execute(f'SELECT * FROM Practices WHERE practice_id = {practice_id}')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    data = cursor.fetchall()
    for row in data:
        row_dict = dict(zip(row_headers, row))
        row_dict['time'] = str(row_dict['time'])
        json_data.append(row_dict)
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

@events.route('/practices', methods=['POST'])
def add_practices():
    # Collecting data from the request object
    data = request.json
    current_app.logger.info(data)

    # Extracting the variable
    date = data['time']
    time = data['date']
    state = data['state']
    city = data['city']
    park = data['park']

    # Constructing the query
    query = (
    'INSERT INTO Games (date, time, state, city, park) '
    'VALUES ("{}", "{}", "{}", "{}", "{}")'
    ).format(date, time, state, city, park)
    current_app.logger.info(query)    

    # Executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'