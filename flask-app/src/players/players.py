from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


players = Blueprint('players', __name__)

@players.route('/players', methods=['GET'])
def get_players():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Players')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@players.route('/players', methods=['POST'])
def add_new_product():
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    first = the_data['first_name']
    last = the_data['last_name']
    email = the_data['email']
    phone = the_data['phone']
    address = the_data['address']
    playerId = the_data['player_id']

    # Constructing the query
    query = 'insert into players (lastName, firstName, email, address, phone, player_id) values ("'
    query += last + '", "'
    query += first + '", "'
    query += email + '", '
    query += address + '", '
    query += phone + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'


@players.route('/players/<player_id>', methods=['DELETE'])
def delete_player(player_id):
    # Constructing the query
    query = f'DELETE FROM players WHERE player_id = {player_id}'
    
    # executing and committing the delete statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Player deleted successfully'

@players.route('/players/<player_id>', methods=['GET'])
def get_player(player_id):
    # Constructing the query
    query = f'SELECT * FROM players WHERE player_id = {player_id}'
    
    # executing the query
    cursor = db.get_db().cursor()
    cursor.execute(query)
    
    # fetching the player data
    row_headers = [x[0] for x in cursor.description]
    player_data = cursor.fetchone()
    
    # checking if player exists
    if player_data is None:
        return make_response(jsonify({'error': 'Player not found'}), 404)
    
    # constructing the JSON response
    json_data = dict(zip(row_headers, player_data))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    
    return the_response

    