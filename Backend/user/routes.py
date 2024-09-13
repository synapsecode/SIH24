from flask import render_template, request, Blueprint, jsonify
from Backend.models import User
from Backend import db
user = Blueprint('user', __name__)

@user.route("/")
def user_home():
	return "This is the user module of TrashHubBackend"


@user.route('/get_user_points/<id>')
def get_user_points(id):
	u = User.query.filter_by(id=id).first()
	if(u == None):
		return "No User Found", 400
	return jsonify({
		'points': u.points,
	})

@user.route('/get_id_by_username/<uname>')
def getid_by_username(uname):
	u = User.query.filter_by(username=uname).first()
	if(u == None):
		return "No User Found", 400
	return jsonify({
		'id': u.id
	})

@user.route("/register", methods=['POST'])
def user_register():
	data = request.json
	if(data == None or data == ''):
		return 'Invalid Request Body', 400
	
	u = User.query.filter_by(username=data['username']).first()
	if(u != None):
		return 'User Already Exists', 400

	u = User(data['name'], data['username'], data['password'])
	db.session.add(u)
	db.session.commit()
	return "User Registered!", 200

@user.route('/login', methods=['POST'])
def user_login():
	data = request.json
	if(data == None or data == ''):
		return 'Invalid Request Body', 400
	u = User.query.filter_by(username=data['username'], password=data['password']).first()
	if(u == None):
		return jsonify({
			'success': False,
			'message': 'User Not Found'
		})
	return jsonify({
		'success': True,
		'id': u.id
	})