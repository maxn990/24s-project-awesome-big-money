from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

organizations = Blueprint('organizations', __name__)

#######################################################
## LEAGUE ROUTES
#######################################################

@organizations.route('/leagues', methods=['GET'])
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

@organizations.route('/leagues', methods=['POST'])
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


@organizations.route('/leagues/<league_id>', methods=['PUT'])
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

@organizations.route('/teams', methods=['GET'])
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

@organizations.route('/teams', methods=['POST'])
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


@organizations.route('/teams/<league_id>', methods=['GET'])
def get_team_by_id(league_id):
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

 
@organizations.route('/teams/<team_id>', methods=['DELETE'])
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

@organizations.route('/playerTeams/<coach_id>', methods=['GET'])
def get_playerTeams_id(coach_id):
    cursor = db.get_db().cursor()
    cursor.execute(('SELECT pt.player_id AS player_id, '
                            'pt.team_id AS team_id, '
                            'p.lastName AS player_lastName, '
                            'p.firstName AS player_firstName, '
                            'p.email AS player_email, '
                            'p.address AS player_address, '
                            'p.phone AS player_phone, '
                            't.team_id AS team_id, '
                            'createdAt, season, teamName, league_id, wins, losses, '
                            'coach_id, '
                            'c.firstName AS coach_firstName, '
                            'c.lastName AS coach_lastName '
                    'FROM PlayerTeams pt '
                    'JOIN Players p ON pt.player_id = p.player_id '
                    'JOIN Teams t ON pt.team_id = t.team_id '
                    'JOIN Coaches c ON t.team_id = c.team_id '
                    'WHERE c.coach_id = {};').format(coach_id))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    data = cursor.fetchall()
    for row in data:
        json_data.append(dict(zip(row_headers, row)))
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

@organizations.route('/playerTeams/<player_id>/<team_id>', methods=['DELETE'])
def delete_playerTeams(player_id, team_id):
    # Constructing the query
    query = f'DELETE FROM PlayerTeams WHERE player_id = {player_id} AND team_id = {team_id}'
    
    # executing and committing the delete statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'PlayerTeams deleted successfully'

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

