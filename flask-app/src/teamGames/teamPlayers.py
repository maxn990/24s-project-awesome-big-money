from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

@teams.route('/teamPlayers', methods=['GET'])
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