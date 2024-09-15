from Backend import db
from flask import jsonify, render_template, request, Blueprint
from Backend.models import (BinoccularDustbin, ProductBatch, ProductEntity,
				       TrashTagManufacturer, TrashTagProduct, 
					   TrashTagVendor, User)

ecoperks = Blueprint('ecoperks', __name__)

@ecoperks.route("/")
def ecoperks_home():
	return "This is the ecoperks module of TrashHubBackend"


# =============================== [ VENDOR ] =============================
@ecoperks.route("/vendor/register", methods=['GET','POST'])
def vendor_register():
	if(request.method == 'GET'):
		return render_template('vendor_register.html')
	data = request.json
	uname = data['username']
	name = data['name']
	password = data['password']
	if(None in [uname, name, password]):
		return "Invalid Payload", 400
	
	v = TrashTagVendor.query.filter_by(username=uname).first()
	if(v != None):
		return 'Vendor already exists', 400
	
	v = TrashTagVendor(name=name, username=uname, password=password)
	db.session.add(v)
	db.session.commit()
	return 'Registered!'

@ecoperks.route('/vendor/login', methods=['GET','POST'])
def vendor_login():
	if(request.method == 'GET'):
		return render_template('vendor_login.html')
	data = request.json
	if(data == None or data == ''):
		return 'Invalid Request Body', 400
	v = TrashTagVendor.query.filter_by(username=data['username'], password=data['password']).first()
	if(v == None):
		return jsonify({
			'success': False,
			'message': 'Vendor Not Found'
		})
	return jsonify({
		'success': True,
		'id': v.id
	})

@ecoperks.route('/vendor/<id>')
def vendor_home(id):
	v = TrashTagVendor.query.filter_by(id=id).first()
	vname = v.name
	if v is None:
		return 'Vendor Not Found', 404
	bins = BinoccularDustbin.query.filter_by(vendor_id=id).all()
	qrbins = [b.toJson() for b in bins]
	bincount = len(qrbins)
	print(bincount)
	vpoints=v.points
	# return jsonify(product_list), 200
	return render_template('vendor_home.html', qrbins=qrbins, bincount=bincount, vname=vname,vid=id, vpoints=vpoints)


# @ecoperks.route("/vendor/scan", methods=['POST'])
# def vendor_scan_qr():
# 	data = request.json
# 	qrcode = data['qrcode']
# 	vid = data['vid']
# 	if(qrcode == None or vid == None):
# 		return "Invalid Payload", 400
# 	v = TrashTagVendor.query.filter_by(id=vid).first()
# 	if(v == None):
# 		return "Invalid Vendor", 400
# 	bid, eid = qrcode.split(':') #batchid:entityid
# 	bat = ProductBatch.query.filter_by(id=bid).first()
# 	if(bat == None):
# 		return "Invalid Batch", 400
# 	ent = ProductEntity.query.filter_by(id=eid, batch=bat).first()
# 	if(ent == None):
# 		return "Invalid Entity", 400
# 	if(ent.purchased):
# 		return "Already Scanned", 400
	
# 	#Purchase the Entity
# 	ent.purchased = True

# 	#Award some points to vendor
# 	v.points = v.points + 5

# 	db.session.commit()

# 	return "Purchased", 200


# ===================================[ MANUFACTURER ]========================================


def manufacturer_home_core(id, api=False):
	m = TrashTagManufacturer.query.filter_by(id=id).first()
	if m is None:
		return 'Manufacturer Not Found', 404
	products = m.products
	product_list = [{'id': p.id, 'name': p.name} for p in products]
	if(api):
		return jsonify(product_list), 200
	return render_template('manufacturer_home.html', products=products)

@ecoperks.route('/manufacturer/<id>')
def manufacturer_home(id):
	return manufacturer_home_core(id)

@ecoperks.route('/manufacturer/<id>/api')
def manufacturer_home_api(id):
	return manufacturer_home_core(id, api=True)

@ecoperks.route("/manufacturer/register", methods=['GET', 'POST'])
def manufacturer_register():
	if(request.method == 'GET'):
		return render_template('manufacturer_register.html')
	data = request.json
	uname = data['username']
	name = data['name']
	password = data['password']
	if(None in [uname, name, password]):
		return "Invalid Payload", 400
	
	m = TrashTagManufacturer.query.filter_by(username=uname).first()
	if(m != None):
		return 'Manufacturer already exists', 400
	
	m = TrashTagManufacturer(name=name, username=uname, password=password)
	db.session.add(m)
	db.session.commit()
	return jsonify({
		'success': True,
		'id': m.id
	}), 200

@ecoperks.route('/manufacturer/login', methods=['POST', 'GET'])
def manufacturer_login():
	if(request.method == 'GET'):
		return render_template('manufacturer_login.html')
	data = request.json
	if(data == None or data == ''):
		return 'Invalid Request Body', 400
	m = TrashTagManufacturer.query.filter_by(username=data['username'], password=data['password']).first()
	if(m == None):
		return jsonify({
			'success': False,
			'message': 'Manufacturer Not Found',
			'name': None
		}), 404
	return jsonify({
		'success': True,
		'id': m.id,
		'name': m.name
	}), 200

@ecoperks.route('/manufacturer/create_product', methods=['POST'])
def create_product():
	data = request.json
	if(data == None or data == ''):
		return 'Invalid Request Body', 400
	
	mid = data['manufacturer_id']
	name = data['product_name']
	if(None in [mid, name]):
		return "Invalid Payload", 400
	
	m = TrashTagManufacturer.query.filter_by(id=mid).first()
	if(m == None):
		return 'Manufacturer not found', 400
	
	p = TrashTagProduct(name=name, manufacturer=m)
	db.session.add(p)
	db.session.commit()

	return jsonify({
		'success': True,
		'id': p.id
	}), 200

def get_product_batches_core(mid,pid,api=False):
	m = TrashTagManufacturer.query.filter_by(id=mid).first()
	if(m == None):
		return 'Manufacturer Not Found'
	p = TrashTagProduct.query.filter_by(id=pid).first()
	if(p == None):
		return 'Product Not Found'
	batches = p.batches
	batch_list = [{'id': b.id, 'size': len(b.entities)} for b in batches]
	if(api):
		return jsonify(batch_list), 200
	return render_template('manufacturer_batches.html', batches=batches)

@ecoperks.route('/manufacturer/<mid>/products/<pid>/batches')
def get_product_batches(mid, pid):
	return get_product_batches_core(mid,pid)

@ecoperks.route('/manufacturer/<mid>/products/<pid>/batches/api')
def get_product_batche_api(mid, pid):
	return get_product_batches_core(mid,pid,api=True)


@ecoperks.route('/manufacturer/create_batch', methods=['POST'])
def create_batch():
	data = request.json
	if(data == None or data == ''):
		return 'Invalid Request Body', 400
	
	mid = data['manufacturer_id']
	pid = data['product_id']
	size = data['size']

	if(None in [mid, pid]):
		return "Invalid Payload", 400
	
	m = TrashTagManufacturer.query.filter_by(id=mid).first()
	if(m == None):
		return 'Manufacturer not found', 400
	
	p = TrashTagProduct.query.filter_by(id=pid).first()
	if(p == None):
		return 'Product not found', 400
	
	b = ProductBatch(product=p)
	db.session.add(b)
	db.session.commit()

	# b = ProductBatch.query.filter_by(product_id=p.id).last()
	# if(b == None):
	# 	return 'ProductBatch could not be refound'

	entities = []
	for _ in range(size):
		e = ProductEntity(batch=b)
		entities.append(e)
	
	db.session.add_all(entities)
	db.session.commit()

	return jsonify({
		'success': True,
		'id': b.id
	}), 200

def get_batch_qrset_core(bid, api=False):
	b = ProductBatch.query.filter_by(id=bid).first()
	if(b == None):
		return 'Batch Does Not Exist', 400
	codes = []
	for e in b.entities:
		codes.append(f'{b.id}:{e.id}')
	print(f'Generated Codes => {codes}')
	if(api):
		return jsonify(codes)

	return render_template('qrset.html', codes=codes)

@ecoperks.route('/manufacturer/get_batch_qrset/<bid>')
def get_batch_qrset(bid):
	return get_batch_qrset_core(bid)

@ecoperks.route('/manufacturer/get_batch_qrset/<bid>/api')
def get_batch_qrset_api(bid):
	return get_batch_qrset_core(bid, api=True)


def get_analytics_core(mid, api=False):
	m = TrashTagManufacturer.query.filter_by(id=mid).first()
	if(m == None):
		return 'Manufacturer does not Exist', 400
	out = []
	for product in m.products:
		blist = []
		for batch in product.batches:
			
			dc = batch.get_disposed_count()
			pc = batch.get_purchased_count()
			blist.append({
				'batch_id': batch.id,
				'batch_size': len(batch.entities),
				'disposed': dc,
				'purchased': pc
			})
		out.append({
			'product': product.name,
			'product_id': product.id,
			'data': blist
		})

	if(api):
		return jsonify(out), 200
	return render_template('manufacturer_analytics.html', analytics=out)


@ecoperks.route('/manufacturer/<mid>/analytics/api')
def get_analytics_api(mid):
	return get_analytics_core(mid,api=True)

@ecoperks.route('/manufacturer/<mid>/analytics')
def get_analytics(mid):
	return get_analytics_core(mid,api=False)

# ===================================[ USER ]========================================

@ecoperks.route("/userscan", methods=['POST'])
def user_scan_qr():
	data = request.json
	productcode = data['productcode'] if 'productcode' in data else None
	dustbincode = data['dustbincode'] if 'dustbincode' in data else None
	uid = data['uid']
	if(None in [productcode, dustbincode, uid]):
		return "Invalid Payload", 400

	# Check for User Validity
	u = User.query.filter_by(id=uid).first()
	if(u == None):
		return "Invalid User", 400

	#Check for Product Validity
	bid, eid = productcode.split(':') #batchid:entityid
	bat = ProductBatch.query.filter_by(id=bid).first()
	if(bat == None): return "Invalid Batch", 400
	ent = ProductEntity.query.filter_by(id=eid, batch=bat).first()
	if(ent == None): return "Invalid Entity", 400

	#Check for Dustbin Validity
	binid, vid, blat, blng = dustbincode.split(':')
	if(None in [binid, vid, blat, blng]):
		return "Invalid Dustbin QR", 400
	
	dustbin = BinoccularDustbin.query.filter_by(id=binid).first()
	if(dustbin == None):
		return "QRBIN does not exist!", 400
	vid = dustbin.vendor_id
	if(vid != None):
		vndr = TrashTagVendor.query.filter_by(id=vid).first()
		if(vndr):
			vndr.points += 0.5 #Add  Points for each disposal
		else:
			print('Vendor Does not Exist! Skipping')
	else:
		print('QRBIN does not have a VendorID; Skipping')

	if(ent.disposed):
		p_uid = ent.disposed_by
		prev_u = User.query.filter_by(id=p_uid).first()
		if(prev_u == None): 
			return "Already Disposed", 200
		prev_u.points = prev_u.points - 10
		u.points = u.points + 10
		db.session.commit()
		return "Re-Disposed", 200
	
	#Dispose the Entity
	ent.disposed = True
	ent.disposed_by = u.id

	#Award some points to user
	u.points = u.points + 10

	db.session.commit()
	return "Disposed", 200

@ecoperks.route("/add_dustbin", methods=['POST'])
def add_dustbin():
	data = request.json
	name = data['name']
	type = data['type']
	location = data['location']
	lat = location['lat']
	lng = location['lng']
	vid = data['vid'] if 'vid' in data else None


	if name is None or type is None or location is None:
		return "Missing Parameters", 400
	
	if type == 'QRBIN':
		if vid is None:
			return "Vendor Id required", 400
	
	lat = float(lat)
	lng = float(lng)
	# 1 degree of lat/lng is 111km => 1km = 0.00900901 degrees
	thresh = (0.05 * 0.00900901)

	if type != "QRBIN":
		nearby_bins = BinoccularDustbin.query \
			.filter(BinoccularDustbin.type == type) \
			.filter(BinoccularDustbin.lat <= lat + thresh)\
			.filter(BinoccularDustbin.lat >= lat - thresh)\
			.filter(BinoccularDustbin.lng <= lng + thresh)\
			.filter(BinoccularDustbin.lng >= lng - thresh)\
			.all()

		if nearby_bins:
			return "Dustbin already exists in this area", 400

	dustbin = BinoccularDustbin(name=name, type=type,lat=lat,lng=lng,vid=vid)

	db.session.add(dustbin)
	db.session.commit()
	return "Dustbin Added", 200

@ecoperks.route("/get_leaderboard", methods = ['GET'])
def get_leaderboard():
	u = User.query.order_by(User.points.desc())
	leaderboard = [user.toJson() for user in u]
	return jsonify(leaderboard), 200


@ecoperks.route("/bulk_add_dustbin", methods=['POST'])
def bulk_add_dustbin():
	data = request.json
	data = data['data']
	bins = []
	for x in data:
		parts = x.split(' ')
		name = parts[2]
		typ = parts[3]
		lat = parts[0]
		lng = parts[1]
		vid = 3
		if(None in [name,typ,lat,lng,vid]):
			continue
		dustbin = BinoccularDustbin(name=name, type=typ,lat=lat,lng=lng,vid=vid)
		bins.append(dustbin)
	db.session.add_all(bins)
	db.session.commit()
	return "Bulk Import Completed!", 200