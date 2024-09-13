from flask import render_template, request, Blueprint, jsonify
from Backend.models import BinoccularDustbin
from Backend import db

binocculars = Blueprint('binocculars', __name__)

@binocculars.route("/")
def binocculars_home():
	return "This is the binocculars module of TrashTraceBackend"

@binocculars.route("/get_all")
def get_all_dusbins():
	bins = BinoccularDustbin.query.all()
	retobj = []
	for bin in bins:
		retobj.append(bin.toJson())
	return jsonify(retobj)

@binocculars.route("/get_proximal/<lat>/<lng>/<radius>")
def get_proximal_dusbins(lat, lng, radius):
	lat = float(lat)
	lng = float(lng)
	radius = float(radius)
	# 1 degree of lat/lng is 111km => 1km = 0.00900901 degrees
	thresh = (float(radius) * 0.00900901)

	def dist(x1,y1,x2,y2):
		import math
		return math.sqrt((x2 - x1)**2 + (y2 - y1)**2)

	# Bounding Box to Prevent OverSearching
	bins = BinoccularDustbin.query \
		.filter(BinoccularDustbin.lat <= lat + thresh)\
		.filter(BinoccularDustbin.lat >= lat - thresh)\
		.filter(BinoccularDustbin.lng <= lng + thresh)\
		.filter(BinoccularDustbin.lng >= lng - thresh)\
		.all()

	retobj = []
	for b in bins:
		distance = dist(lat, lng, float(b.lat), float(b.lng))
		if(distance <= thresh):
			retobj.append(b.toJson())
	return jsonify(retobj)

@binocculars.route("/add_bin", methods=['POST'])
def add_dustbin():
	data = request.json
	if(data == None or len(data)==0): return "Request Payload is Empty", 400
	b = BinoccularDustbin(data['name'], data['type'], data['lat'], data['lng'])
	db.session.add(b)
	db.session.commit()
	return "Bin Added", 200

@binocculars.route("/remove_bin/<id>")
def remove_dustbin(id):
	b = BinoccularDustbin.query.filter_by(id=id).first()
	if(b == None): return "Bin does not exist", 400
	db.session.delete(b)
	db.session.commit()
	return "Bin Removed", 200

@binocculars.route("/edit_bin/<id>", methods=['POST'])
def edit_dustbin(id):
	data = request.json
	if(data == None or len(data)==0): return "Request Payload is Empty", 400
	b = BinoccularDustbin.query.filter_by(id=id).first()
	if(b == None): return "Bin does not exist", 400

	# Modifying Values
	b.name = str(data['name']) if (data['name'] != None or data['name'] != '') else b.name
	b.type = str(data['type']) if (data['type'] != None or data['type'] != '') else b.type
	b.lat = float(str(data['lat'])) if (data['lat'] != None or data['lat'] != '') else b.lat
	b.lng = float(str(data['lng'])) if (data['lng'] != None or data['lng'] != '') else b.lng

	db.session.commit()
	return "Bin Edited!", 200


"""
Working of LatLng proximity Demostration

lat  12.924602551376156
lng  77.58813373317656

range = 2km
thresh = 0.01801802
0.02548132821767859

12.9065845314 <= lat <= 12.9426205714
77.5701157132 <= lng <= 77.6061517532

geo fix 77.58813373317656 12.924602551376156


range = 300 m
thresh = 0.002702703

12.9218998484 <= lat <= 12.9273052544
77.5854310302 <= lng <= 77.5908364362
"""