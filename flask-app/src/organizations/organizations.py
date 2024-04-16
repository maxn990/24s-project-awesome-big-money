from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

organizations = Blueprint('organizations', __name__)

#######################################################
## LEAGUE ROUTES
#######################################################

@organizations.route('/leagues', methods=['GET'])
def get_league():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Leagues')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@organizations.route('/leagues', methods=['POST'])
def add_new_league():
    
    # collecting data from the request object
    the_data = request.json
    current_app.logger.info(the_data)

    # extracting the variable
    sportType = the_data['sport_type']
    name = the_data['name']
    manager_id = the_data['email']
    phone = the_data['manager_id']
    league_id = the_data['league_id']

    # Constructing the query
    query = 'insert into Leagues (sportType, name, manager_id, phone, league_id) values ("'
    query += sportType + '", "'
    query += name + '", "'
    query += manager_id + '", '
    query += phone + '", '
    query += league_id + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
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
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@organizations.route('/teams', methods=['POST'])
def add_new_team():
    # collecting data from the request object
    the_data = request.json
    current_app.logger.info(the_data)
    # extracting the variables
    season = the_data['season']
    league_id = the_data['league_id']
    team_name = the_data['teamName']
    # Constructing the query
    query = 'INSERT INTO Teams (season, teamName,league_id) VALUES ("{}", "{}", "{}")'.format(season, team_name, league_id)
    current_app.logger.info(query)
    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'

@organizations.route('/teams/<team_id>', methods=['GET'])
def get_team_by_id(team_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Teams WHERE team_id = %s', (team_id,))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


@organizations.route('/teamPlayers', methods=['GET'])
def get_teamPlayers(player_id):
    cursor = db.get_db().cursor()
    cursor.execute('''
        SELECT player.* 
        FROM player
        JOIN teams ON player.player_id = team.player_id
        WHERE teams.player_id = %s
    ''', (player_id,))
    
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@organizations.route('/teamPractices', methods=['GET'])
def get_teamPractices(practice_id):
    cursor = db.get_db().cursor()
    cursor.execute('''
        SELECT practice.* 
        FROM practice
        JOIN teams ON practice.practice_id = team.practice_id
        WHERE teams.practice_id = %s
    ''', (practice_id,))
    
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response