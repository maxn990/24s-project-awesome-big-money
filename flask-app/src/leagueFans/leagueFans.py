from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

@leagues.route('/leaguesFans', methods=['GET'])
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