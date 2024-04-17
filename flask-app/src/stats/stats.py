from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

stats = Blueprint('stats', __name__)


#######################################################
## PLAYER PROFILE ROUTES
#######################################################


@stats.route('/playerProfile', methods=['GET'])
def get_player_profile():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM PlayerProfile pa '
                    'JOIN Players p ON pa.player_id = p.player_id')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    data = cursor.fetchall()
    for row in data:
        json_data.append(dict(zip(row_headers, row)))
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response

@stats.route('/playerProfile/<player_id>', methods=['GET'])
def get_player_profile_player_id(player_id):
    cursor = db.get_db().cursor()
    cursor.execute(f'SELECT * FROM PlayerProfile WHERE player_id = {player_id}')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    data = cursor.fetchall()
    for row in data:
        json_data.append(dict(zip(row_headers, row)))
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response


@stats.route('/playerProfile', methods=['POST'])
def add_player_profile():
    # collecting data from the request object 
    data = request.json
    current_app.logger.info(data)

    #extracting the variable
    player_id = data['player_id']
    sport = data['sport']
    fouls = data['fouls']
    points = data['points']
    assists = data['assists']

    # Constructing the query
    query = (
    'INSERT INTO PlayerProfile (player_id, sport, points, assists, fouls) '
    'VALUES ("{}", "{}", "{}", "{}", "{}")'
    ).format(player_id, sport, points, assists, fouls)
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'

@stats.route('/playerProfile', methods=['PUT'])
def update_player_profile():
    # collecting data from the request object 
    data = request.json
    current_app.logger.info(data)

    #extracting the variable
    player_id = data['player_id']
    sport = data['sport']
    fouls = data['fouls']
    assists = data['assists']
    points = data['points']

    # Constructing the query
    query = ('UPDATE PlayerProfile SET fouls = {}, assists = {}, points = {} '
             'WHERE player_id = {} AND sport = "{}"'.format
             (fouls, assists, points, player_id, sport))    
    current_app.logger.info(query)

    # executing and committing the update statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'


#######################################################
## PLAYER STATS ROUTES
#######################################################

@stats.route('/playerStats/<player_id>', methods=['GET'])
def get_player_stats(player_id):
    cursor = db.get_db().cursor()
    cursor.execute(('SELECT * FROM PlayerStats ps '
                    'JOIN Games g ON ps.game_id = g.game_id '
                    'WHERE ps.player_id = {};').format(player_id))
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

@stats.route('/playerStats/<player_id>/<game_id>', methods=['GET'])
def get_player_stats_game_id(player_id,game_id):
    cursor = db.get_db().cursor()
    cursor.execute(('SELECT * FROM PlayerStats ps '
                    'JOIN Games g ON ps.game_id = g.game_id '
                    'WHERE ps.player_id = {} AND ps.game_id = {};').format
                    (player_id, game_id))
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

@stats.route('/playerStats/<player_id>/<game_id>', methods=['POST'])
def add_player_stats(player_id, game_id):
    # collecting data from the request object 
    data = request.json
    current_app.logger.info(data)

    #extracting the variable
    playerId = data['player_id']
    game_id = data['game_id']

    # Constructing the query
    query = 'insert into PlayerStats (player_id, game_id) values ("'
    query += str(player_id) + '", "'
    query += game_id + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'

@stats.route('/playerStats/<player_id>/<game_id>', methods=['PUT'])
def update_player_stats(player_id, game_id):
    # collecting data from the request object 
    data = request.json
    current_app.logger.info(data)

    #extracting the variable
    fouls = data['fouls']
    assists = data['assists']
    points = data['points']

    # Constructing the query
    query = ('UPDATE playerStats SET fouls = {}, assists = {}, points = {} '
             'WHERE player_id = {} AND game_id = "{}"'.format
             (fouls, assists, points, player_id, game_id))
    current_app.logger.info(query)

    # executing and committing the update statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'


#######################################################
## TEAM STATS ROUTES
#######################################################


@stats.route('/teamStats/<team_id>/<game_id>', methods=['GET'])
def get_team_stats(team_id, game_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM teamStats WHERE team_id = {} AND game_id = "{}"'.format(team_id, game_id))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    data = cursor.fetchall()
    for row in data:
        json_data.append(dict(zip(row_headers, row)))
    response = make_response(jsonify(json_data))
    response.status_code = 200
    response.mimetype = 'application/json'
    return response
    
@stats.route('/teamStats', methods=['POST'])
def add_team_stats():
    # Collecting data from the request object 
    data = request.json
    current_app.logger.info(data)

    # Extracting the variable
    team_id = data['team_id']
    game_id = data['game_id']
    points = data['points']
    fouls = data['fouls']
    assists = data['assists']

    # Constructing the query
    query = (
    'INSERT INTO Games (team_id, game_id, points, assists, fouls) '
    'VALUES ("{}", "{}", "{}", "{}", "{}")'
    ).format(team_id, game_id, points, assists, fouls)
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'

@stats.route('/teamStats', methods=['PUT'])
def update_player_profile_team():
    # collecting data from the request object 
    data = request.json
    current_app.logger.info(data)

    #extracting the variable
    team_id = data['team_id']
    game_id = data['game_id']
    fouls = data['fouls']
    assists = data['assists']
    points = data['points']

    # Constructing the query
    query = ('UPDATE teamStats SET fouls = {}, assists = {}, points = {} '
             'WHERE team_id = {} AND game_id = "{}"'.format
             (fouls, assists, points, team_id, game_id))
    current_app.logger.info(query)

    # executing and committing the update statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'