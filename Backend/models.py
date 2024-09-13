#Database Layer
from datetime import datetime
from typing import Dict
from sqlalchemy.ext.hybrid import hybrid_method
from Backend import db

class User(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	name = db.Column(db.String)
	username = db.Column(db.String)
	password = db.Column(db.String)

	points = db.Column(db.Float, default=0.0)

	# Relationships
	RCXJobs = db.relationship('RCXJob', backref='client')
	

	def __repr__(self):
		return f"User({self.name}, {self.username})"
	
	def __init__(self, name, username, password):
		self.name = name
		self.username = username
		self.password = password

# ============================ (BinOcculars) ================================

class BinoccularDustbin(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	name = db.Column(db.String)
	type = db.Column(db.String)
	lat = db.Column(db.Float)
	lng = db.Column(db.Float)

	def __repr__(self):
		return f"BinOccularDusbin({self.name}, {self.name}, ({self.lat}, {self.lng}))"
	
	def __init__( self, name='default', type='regular', lat=0.0, lng=0.0):
		self.name = str(name)
		self.type = str(type)
		self.lat = float(str(lat))
		self.lng = float(str(lng))

	def toJson(self) -> Dict:
		return {
			'name': self.name,
			'type': self.type,
			'lat': self.lat,
			'lng': self.lng,
		}

# ============================ (TrashTag) ================================

class TrashTagVendor(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	name = db.Column(db.String)
	username = db.Column(db.String)
	password = db.Column(db.String)
	points = db.Column(db.Float, default=0.0)

	def __init__(self, name, username,password):
		self.name = name
		self.username = username
		self.password = password


class TrashTagManufacturer(db.Model):
	__tablename__ = 'trashtag_manufacturer'
	id = db.Column(db.Integer, primary_key=True)
	name = db.Column(db.String)
	username = db.Column(db.String)
	password = db.Column(db.String)

	#[relationships]
	products = db.relationship('TrashTagProduct', backref='manufacturer')

	def __init__(self, name, username, password):
		self.name = name
		self.username = username
		self.password = password


class TrashTagProduct(db.Model):
	__tablename__ = 'trashtag_product'
	id = db.Column(db.Integer, primary_key=True)
	name = db.Column(db.String)
	batches = db.relationship('ProductBatch', backref='product', cascade='delete')

	manufacturer_id = db.Column(db.Integer, db.ForeignKey('trashtag_manufacturer.id'))

	def __init__(self, name, manufacturer):
		self.name = name
		self.manufacturer = manufacturer


class ProductBatch(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	product_id = db.Column(db.Integer, db.ForeignKey('trashtag_product.id'))

	def __init__(self, product):
		self.product = product

	#relationships
	entities = db.relationship('ProductEntity', backref='batch', cascade='delete')

	def get_disposed_count(self):
		count = 0
		for entity in self.entities:
			if(entity.disposed):
				count += 1
		return count
	
	def get_purchased_count(self):
		count = 0
		for entity in self.entities:
			if(entity.purchased):
				count += 1
		return count

	#[backref]
	#product

class ProductEntity(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	batch_id = db.Column(db.Integer, db.ForeignKey('product_batch.id'))
	disposed = db.Column(db.Boolean, default=False)
	purchased = db.Column(db.Boolean, default=False)

	def __init__(self, batch):
		self.batch = batch

	#[backref]
	#batch

# ============================ (ReCyclX) ================================


class RCXPartner(db.Model):
	__tablename__ = 'rcx_partner'
	id = db.Column(db.Integer, primary_key=True)
	name = db.Column(db.String)
	type = db.Column(db.String)
	username = db.Column(db.String)
	password = db.Column(db.String)

	jobs = db.relationship('RCXJob', backref='partner')

	def __init__(self, name, type, username, password):
		self.name = name
		self.type = type
		self.username = username
		self.password = password

class RCXJob(db.Model):
	__tablename__ = 'rcx_job'
	id = db.Column(db.Integer, primary_key=True)
	name = db.Column(db.String)
	status = db.Column(db.String)
	date = db.Column(db.DateTime, default=datetime.now)
	lat = db.Column(db.Float) # User Location 
	lng = db.Column(db.Float) # User Location 

	#[foreignkeys]
	partner_id = db.Column(db.Integer, db.ForeignKey('rcx_partner.id'))
	client_id = db.Column(db.Integer, db.ForeignKey('user.id'))

	#[backrefs]
	#partner = <Partner>
	#client = <User>

	def __init__(self, name, status, lat, lng, client, partner):
		self.name = name
		self.status = status
		self.lat = lat
		self.lng = lng
		self.client = client
		self.partner = partner

	def __repr__(self):
		return f'RCXJob({self.name}, {self.status}, {self.client}, {self.partner})'