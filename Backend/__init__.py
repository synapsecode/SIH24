from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from Backend.config import Config
from flask_cors import CORS
from flask_qrcode import QRcode


db = SQLAlchemy()

def create_app(config_class=Config):
	app = Flask(__name__)
	app.config.from_object(Config)
	db.init_app(app)
	QRcode(app)
	app._static_folder = Config().UPLOAD_FOLDER

	#Import all your blueprints
	from Backend.main.routes import main
	from Backend.binocculars.routes import binocculars
	from Backend.user.routes import user
	# from TrashHubBackend.recyclehub.routes import recyclehub
	from Backend.ecoperks.routes import ecoperks
	
	#use the url_prefix arguement if you need prefixes for the routes in the blueprint
	app.register_blueprint(main)
	app.register_blueprint(user, url_prefix='/user')
	# app.register_blueprint(recyclehub, url_prefix='/recyclehub')
	app.register_blueprint(ecoperks, url_prefix='/ecoperks')
	app.register_blueprint(binocculars, url_prefix='/binocculars')
	CORS(app)

	return app

#Helper function to create database file directly from terminal
def create_database():
	# import Backend.models
	print("Creating App & Database")
	app = create_app()
	with app.app_context():
		db.create_all()
		db.session.commit()
	print("Successfully Created Database")
