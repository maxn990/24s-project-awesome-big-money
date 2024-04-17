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
    data = cursor.fetchall()
    for row in data:
        json_data.append(dict(zip(row_headers, row)))
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

@users.route('/players', methods=['POST'])
def add_players():
    # collecting data from the request object 
    data = request.json
    current_app.logger.info(data)

    #extracting the variable
    first = data['firstName']
    last = data['lastName']
    email = data['email']
    phone = data['phone']
    address = data['address']

    # Constructing the query
    query = (
    'INSERT INTO PlayerProfile (firstName, lastName, email, phone, address) '
    'VALUES ("{}", "{}", "{}", "{}", "{}")'
    ).format(first, last, email, phone, address)
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'


@users.route('/players/<player_id>', methods=['DELETE'])
def delete_player(player_id):
    # Constructing the query
    query = f'DELETE FROM Players WHERE player_id = {player_id}'
    
    # executing and committing the delete statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Player deleted successfully'

#######################################################
## COACH ROUTES
#######################################################

@users.route('/coaches', methods=['GET'])
def get_coaches():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Coaches')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    data = cursor.fetchall()
    for row in data:
        json_data.append(dict(zip(row_headers, row)))
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

@users.route('/coaches', methods=['POST'])
def add_coach():
    # collecting data from the request object 
    data = request.json
    current_app.logger.info(data)

    # extracting the variable
    first = data['firstName']
    last = data['lastName']
    email = data['email']
    phone = data['phone']
    address = data['address']

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
    query = 'DELETE FROM Coaches WHERE coach_id = {}'.format(coach_id)
    
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
    data = cursor.fetchall()
    for row in data:
        json_data.append(dict(zip(row_headers, row)))
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

@users.route('/managers', methods=['POST'])
def add_managers():
    # collecting data from the request object 
    data = request.json
    current_app.logger.info(data)

    #extracting the variable
    first = data['firstName']
    last = data['lastName']
    email = data['email']
    phone = data['phone']
    address = data['address']

    # Constructing the query
    query = (
    'INSERT INTO Managers (firstName, lastName, email, phone, address) '
    'VALUES ("{}", "{}", "{}", "{}", "{}")'
    ).format(first, last, email, phone, address)
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'


@users.route('/managers/<manger_id>', methods=['DELETE'])
def delete_managers(manager_id):
    # Constructing the query
    query = f'DELETE FROM Managers WHERE Managers = {manager_id}'
    
    # executing and committing the delete statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Managers deleted successfully'


@users.route('/managers/<manager_id>', methods=['PUT'])
def update_Managers(manager_id):
    # collecting data from the request object 
    data = request.json
    current_app.logger.info(data)

   #extracting the variable
    first = data['firstName']
    last = data['lastName']
    email = data['email']
    phone = data['phone']
    address = data['address']


    # Constructing the query
    query = ('UPDATE Managers SET firstName = {}, lastName = {}, email = {}, phone = {}, address = {} '
             'WHERE manager_id = {}'.format
             (first, last, email, phone, address, manager_id))
    current_app.logger.info(query)

    # executing and committing the update statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'


#######################################################
## LEAGUE FANS
#######################################################

@users.route('/leagueFans', methods=['GET'])
def get_leagueFans():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM LeagueFans')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    data = cursor.fetchall()
    for row in data:
        json_data.append(dict(zip(row_headers, row)))
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

#######################################################
## PLAYER TEAMS
#######################################################

@users.route('/playerTeams', methods=['GET'])
def get_playerTeams():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM PlayerTeams')
    
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    data = cursor.fetchall()
    for row in data:
        json_data.append(dict(zip(row_headers, row)))
    
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response
    
#######################################################
## FANS
#######################################################

@users.route('/fans', methods=['GET'])
def get_fans():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Fans')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    data = cursor.fetchall()
    for row in data:
        json_data.append(dict(zip(row_headers, row)))
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

@users.route('/fans', methods=['POST'])
def add_fans():
    # collecting data from the request object 
    data = request.json
    current_app.logger.info(data)
    
    # extracting the variables
    first = data['firstName']
    last = data['lastName']
    email = data['email']
    phone = data['phone']
    address = data['address']
    
    # Constructing the query
    query = (
    'INSERT INTO Fans (firstName, lastName, email, address, phone) '
    'VALUES ("{}", "{}", "{}", "{}", "{}")'
    ).format(first, last, email, address, phone)
    current_app.logger.info(query)
    
    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'