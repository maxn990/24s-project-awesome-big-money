from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

organizations = Blueprint('organizations', __name__)

#######################################################
## LEAGUE ROUTES
#######################################################

@organizations.route('/Leagues', methods=['GET'])
def get_leagues():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Leagues')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    data = cursor.fetchall()
    for row in data:
        json_data.append(dict(zip(row_headers, row)))
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

@organizations.route('/Leagues', methods=['POST'])
def add_leagues():
    # Collecting data from the request object
    data = request.json
    current_app.logger.info(data)

    # Extracting the variable
    sportType = data['sport_type']
    name = data['name']
    manager_id = data['email']
    phone = data['manager_id']
    league_id = data['league_id']

    # Constructing the query
    query = (
    'INSERT INTO Coaches (sportType, name, manager_id, phone, league_id) '
    'VALUES ("{}", "{}", "{}", "{}", "{}")'
    ).format(sportType, name, manager_id, phone, league_id)
    current_app.logger.info(query)

    # Executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'


    @stats.route('/Leagues/<league_id>', methods=['PUT'])
def update_Leagues(league_id):
    # collecting data from the request object 
    data = request.json
    current_app.logger.info(data)

   #extracting the variable
    sportType = data['sportType']
    name = data['name']
    manager_id = data['manager_id']


    # Constructing the query
    query = ('UPDATE League SET sportType = {}, name = {}, manager_id = {} '
             'WHERE league_id = {}'.format
             (sportType, name, manager_id, league_id))
    current_app.logger.info(query)

    # executing and committing the update statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'
    

#######################################################
## TEAM ROUTES
#######################################################

@organizations.route('/Teams', methods=['GET'])
def get_teams():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Teams')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    data = cursor.fetchall()
    for row in data:
        json_data.append(dict(zip(row_headers, row)))
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

@organizations.route('/Teams', methods=['POST'])
def add_teams():
    # Collecting data from the request object
    data = request.json
    current_app.logger.info(data)

    # Extracting the variables
    season = data['season']
    league_id = data['league_id']
    teamName = data['teamName']

    # Constructing the query
    query = ('INSERT INTO Teams (season, teamName,league_id) '
            'VALUES ("{}", "{}", "{}")'.format(season, teamName, league_id))
    current_app.logger.info(query)

    # Executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'


@organizations.route('/Teams/<team_id>', methods=['GET'])
def get_team_by_id(team_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Teams WHERE league_id = %s', (league_id))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    data = cursor.fetchall()
    for row in data:
        json_data.append(dict(zip(row_headers, row)))
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

 
 @users.route('/Teams/<team_id>', methods=['DELETE'])
def delete_Teams(team_id):
    # Constructing the query
    query = f'DELETE FROM Teams WHERE Teams = {team_id}'
    
    # executing and committing the delete statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Team deleted successfully'


@organizations.route('/playerTeams', methods=['GET'])
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

@organizations.route('/teamPractices', methods=['GET'])
def get_teamPractices():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM TeamPractices')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    data = cursor.fetchall()
    for row in data:
        json_data.append(dict(zip(row_headers, row)))
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

