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
        json_data.append(dict(zip(row_headers, row)))
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

@events.route('/Practices', methods=['GET'])
def get_practices():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Practices')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    data = cursor.fetchall()
    for row in data:
        json_data.append(dict(zip(row_headers, row)))
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
    