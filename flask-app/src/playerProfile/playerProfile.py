from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


playerProfile = Blueprint('playerProfile', __name__)


@playerProfile.route('/playerProfile/<player_id>/<sport>', methods=['GET'])
def get_player_profile(player_id, sport):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM PlayerProfile WHERE player_id = {} AND sport = "{}"'.format(player_id, sport))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@playerProfile.route('/playerProfile/<player_id>/<sport>', methods=['POST'])
def add_player_information(player_id, sport):
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    playerId = the_data['player_id']
    sport = the_data['sport']

    # Constructing the query
    query = 'insert into PlayerProfile (player_id, sport) values ("'
    query += str(player_id) + '", "'
    query += sport + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'

@playerProfile.route('/playerProfile/<player_id>/<sport>', methods=['PUT'])
def update_player_profile(player_id, sport):
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    fouls = the_data['fouls']
    assists = the_data['assists']
    points = the_data['points']

    # Constructing the query
    query = 'UPDATE PlayerProfile SET fouls = {}, assists = {}, points = {} WHERE player_id = {} AND sport = "{}"'.format(fouls, assists, points, player_id, sport)
    current_app.logger.info(query)

    # executing and committing the update statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'