from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

events = Blueprint('events', __name__)

#######################################################
## PRACTICE ATTENDANCE ROUTES
#######################################################

@events.route('/PracticeAttendance', methods=['GET'])
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

@events.route('/PracticeAttendance/<player_id>', methods=['GET'])
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

@events.route('/PracticeAttendance', methods=['POST'])
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

@events.route('/PracticeAttendance', methods=['DELETE'])
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

@events.route('/GameAttendance', methods=['GET'])
def get_GameAttendance():
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

@events.route('/GameAttendance', methods=['DELETE'])
def delete_GameAttendance():
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

@events.route('/GameCoaches/<coach_id>', methods=['GET'])
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

@events.route('/GameCoaches', methods=['POST'])
def add_GameCoaches():
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

@events.route('/Games', methods=['GET'])
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

@events.route('/Games', methods=['POST'])
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

@events.route('/Practices', methods=['GET'])
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

@events.route('/Practices', methods=['POST'])
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

    @users.route('/Practices/<practice_id>', methods=['DELETE'])
def delete_Practices(practice_id):
    # Constructing the query
    query = f'DELETE FROM Practices WHERE Practices = {practice_id}'
    
    # executing and committing the delete statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Practice deleted successfully'


@stats.route('/Practices/<practice_id>', methods=['PUT'])
def update_Practices(practice_id):
    # collecting data from the request object 
    data = request.json
    current_app.logger.info(data)

   #extracting the variable
    time = data['time']
    date = data['date']
    state = data['state']
    city = data['city']
    park = data['park']


    # Constructing the query
    query = ('UPDATE Practices SET time = {}, date = {}, state = {}, city = {}, park = {} '
             'WHERE practice_id = {}'.format
             (time, date, state, city, park, practice_id))
    current_app.logger.info(query)

    # executing and committing the update statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'
    