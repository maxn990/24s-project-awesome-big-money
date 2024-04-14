from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


coaches = Blueprint('coaches', __name__)

@coaches.route('/coaches', methods=['GET'])
def get_customers():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Coaches')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@coaches.route('/coaches', methods=['POST'])
def add_new_product():
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    first = the_data['first_name']
    last = the_data['last_name']
    email = the_data['email']
    phone = the_data['phone']
    teamId = the_data['team_id']
    coachId = the_data['coach_id']

    # Constructing the query
    query = 'insert into Coaches (coach_id, firstName, lastName, email, phone, team_id) values ("'
    query += first + '", "'
    query += last + '", "'
    query += email + '", '
    query += phone + '", '
    query += phone + '", '
    query += str(team_id) + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'

    @coaches.route('/coaches/<coach_id>', methods=['DELETE'])
    def delete_coach(coach_id):
        # Constructing the query
        query = 'DELETE FROM Coaches WHERE coach_id = {}'.format(coach_id)
        
        # executing and committing the delete statement 
        cursor = db.get_db().cursor()
        cursor.execute(query)
        db.get_db().commit()
        
        return 'Coach deleted successfully'