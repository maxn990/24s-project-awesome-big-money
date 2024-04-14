from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


playerStats = Blueprint('playerStats', __name__)


@playerStats.route('/playerStats/<player_id>/<game_id>', methods=['GET'])
def get_player_profile(player_id, game_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM playerStats WHERE player_id = {} AND game_id = "{}"'.format(player_id, game_id))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@playerStats.route('/playerStats/<player_id>/<game_id>', methods=['POST'])
def add_player_information(player_id, game_id):
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    playerId = the_data['player_id']
    game_id = the_data['game_id']

    # Constructing the query
    query = 'insert into playerStats (player_id, game_id) values ("'
    query += str(player_id) + '", "'
    query += game_id + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'

@playerStats.route('/playerStats/<player_id>/<game_id>', methods=['PUT'])
def update_player_profile(player_id, game_id):
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    fouls = the_data['fouls']
    assists = the_data['assists']
    points = the_data['points']

    # Constructing the query
    query = 'UPDATE playerStats SET fouls = {}, assists = {}, points = {} WHERE player_id = {} AND game_id = "{}"'.format(fouls, assists, points, player_id, game_id)
    current_app.logger.info(query)

    # executing and committing the update statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'