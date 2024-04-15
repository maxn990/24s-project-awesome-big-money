from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


users = Blueprint('users', __name__)


#######################################################
## PLAYER ROUTES
#######################################################

@users.route('/players', methods=['GET'])
def get_players():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Players')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@users.route('/players', methods=['POST'])
def add_new_player():
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    first = the_data['first_name']
    last = the_data['last_name']
    email = the_data['email']
    phone = the_data['phone']
    address = the_data['address']
    playerId = the_data['player_id']

    # Constructing the query
    query = 'insert into Players (lastName, firstName, email, address, phone, player_id) values ("'
    query += last + '", "'
    query += first + '", "'
    query += email + '", '
    query += address + '", '
    query += phone + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'


@users.route('/players/<player_id>', methods=['DELETE'])
def delete_player(player_id):
    # Constructing the query
    query = f'DELETE FROM players WHERE player_id = {player_id}'
    
    # executing and committing the delete statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Player deleted successfully'

@users.route('/players/<player_id>', methods=['GET'])
def get_player(player_id):
    # Constructing the query
    query = f'SELECT * FROM players WHERE player_id = {player_id}'
    
    # executing the query
    cursor = db.get_db().cursor()
    cursor.execute(query)
    
    # fetching the player data
    row_headers = [x[0] for x in cursor.description]
    player_data = cursor.fetchone()
    
    # checking if player exists
    if player_data is None:
        return make_response(jsonify({'error': 'Player not found'}), 404)
    
    # constructing the JSON response
    json_data = dict(zip(row_headers, player_data))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    
    return the_response

#######################################################
## COACH ROUTES
#######################################################

@users.route('/coaches', methods=['GET'])
def get_coaches():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Coaches')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@users.route('/coaches', methods=['POST'])
def add_new_coach():
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    # extracting the variable
    first = the_data['firstName']
    last = the_data['lastName']
    email = the_data['email']
    phone = the_data['phone']
    address = the_data['address']

    # constructing the query
    query = (
    'INSERT INTO Coaches (firstName, lastName, email, phone, address) '
    'VALUES ("{}", "{}", "{}", "{}", "{}")'
    ).format(first, last, email, phone, address)
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'

@users.route('/coaches/<coach_id>', methods=['DELETE'])
def delete_coach(coach_id):
    # Constructing the query
    query = 'DELETE FROM coaches WHERE coach_id = {}'.format(coach_id)
    
    # executing and committing the delete statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Coach deleted successfully'


#######################################################
## MANAGER ROUTES
#######################################################

@users.route('/managers', methods=['GET'])
def get_managers():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Managers')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@users.route('/manager', methods=['POST'])
def add_new_manager():
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    first = the_data['first_name']
    last = the_data['last_name']
    email = the_data['email']
    phone = the_data['phone']
    address = the_data['address']
    manager_id = the_data['manager_id']

    # Constructing the query
    query = 'insert into managers (lastName, firstName, email, address, phone, manager_id) values ("'
    query += last + '", "'
    query += first + '", "'
    query += email + '", '
    query += address + '", '
    query += phone + '", '
    query += str(manager_id) + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'


@users.route('/manager/<manger_id>', methods=['DELETE'])
def delete_player_manager(manager_id):
    # Constructing the query
    query = f'DELETE FROM managers WHERE manager = {manager_id}'
    
    # executing and committing the delete statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Manager deleted successfully'

@users.route('/manager/<manager>', methods=['GET'])
def get_manager(manager_id):
    # Constructing the query
    query = f'SELECT * FROM managers WHERE managers = {manager_id}'
    
    # executing the query
    cursor = db.get_db().cursor()
    cursor.execute(query)
    
    # fetching the player data
    row_headers = [x[0] for x in cursor.description]
    player_data = cursor.fetchone()
    
    # checking if player exists
    if player_data is None:
        return make_response(jsonify({'error': 'Player not found'}), 404)
    
    # constructing the JSON response
    json_data = dict(zip(row_headers, player_data))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    
    return the_response

#######################################################
## LEAGUE FANS
#######################################################

@users.route('/leaguesFans', methods=['GET'])
def get_leagueFans(league_id):
    cursor = db.get_db().cursor()
    cursor.execute('''
        SELECT fan.* 
        FROM fan
        JOIN leagues ON fan.fan_id = leagues.fan_id
        WHERE leagues.league_id = %s
    ''', (league_id,))
    
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

#######################################################
## PLAYER TEAMS
#######################################################

@users.route('/playerTeams', methods=['GET'])
def get_playerTeams(team_id):
    cursor = db.get_db().cursor()
    cursor.execute('''
        SELECT teams.* 
        FROM teams
        JOIN players ON team.team_id = players.team_id
        WHERE players.team_id = %s
    ''', (team_id,))
    
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response