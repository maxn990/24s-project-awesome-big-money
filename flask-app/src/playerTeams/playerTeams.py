from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

@players.route('/players', methods=['GET'])
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