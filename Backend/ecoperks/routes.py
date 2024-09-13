from Backend import db
from flask import jsonify, render_template, request, Blueprint
from Backend.models import (ProductBatch, ProductEntity,
				       TrashTagManufacturer, TrashTagProduct, 
					   TrashTagVendor, User)

ecoperks = Blueprint('ecoperks', __name__)

@ecoperks.route("/")
def ecoperks_home():
	return "This is the ecoperks module of TrashHubBackend"


# =============================== [ VENDOR ] =============================
@ecoperks.route("/vendor/register", methods=['POST'])
def vendor_register():
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

@ecoperks.route('/vendor/login', methods=['POST'])
def vendor_login():
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


@ecoperks.route("/vendor/scan", methods=['POST'])
def vendor_scan_qr():
	data = request.json
	qrcode = data['qrcode']
	vid = data['vid']
	if(qrcode == None or vid == None):
		return "Invalid Payload", 400
	v = TrashTagVendor.query.filter_by(id=vid).first()
	if(v == None):
		return "Invalid Vendor", 400
	bid, eid = qrcode.split(':') #batchid:entityid
	bat = ProductBatch.query.filter_by(id=bid).first()
	if(bat == None):
		return "Invalid Batch", 400
	ent = ProductEntity.query.filter_by(id=eid, batch=bat).first()
	if(ent == None):
		return "Invalid Entity", 400
	if(ent.purchased):
		return "Already Scanned", 400
	
	#Purchase the Entity
	ent.purchased = True

	#Award some points to vendor
	v.points = v.points + 5

	db.session.commit()

	return "Purchased", 200


# ===================================[ MANUFACTURER ]========================================

@ecoperks.route('/manufacturer/<id>')
def manufacturer_home(id):
	m = TrashTagManufacturer.query.filter_by(id=id).first()
	if(m == None):
		return 'Manufacturer Not Found'
	products = m.products
	print(products)
	return render_template('manufacturer_home.html', products=products)

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
	return 'Registered!'

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
			'message': 'Manufacturer Not Found'
		})
	return jsonify({
		'success': True,
		'id': m.id
	})

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

	return f'Product Created with id: {p.id}', 200


@ecoperks.route('/manufacturer/<mid>/products/<pid>/batches')
def get_product_batches(mid, pid):
	m = TrashTagManufacturer.query.filter_by(id=mid).first()
	if(m == None):
		return 'Manufacturer Not Found'
	p = TrashTagProduct.query.filter_by(id=pid).first()
	if(p == None):
		return 'Product Not Found'
	batches = p.batches
	return render_template('manufacturer_batches.html', batches=batches)


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

	return f'ProductBatch of size {size} Created with id: {b.id}', 200

@ecoperks.route('/manufacturer/get_batch_qrset/<bid>')
def get_batch_qrset(bid):
	b = ProductBatch.query.filter_by(id=bid).first()
	if(b == None):
		return 'Batch Does Not Exist', 400
	codes = []
	for e in b.entities:
		codes.append(f'{b.id}:{e.id}')
	print(f'Generated Codes => {codes}')

	return render_template('qrset.html', codes=codes)

@ecoperks.route('/manufacturer/<mid>/analytics')
def get_analytics(mid):
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

	return render_template('manufacturer_analytics.html', analytics=out)

# ===================================[ USER ]========================================

@ecoperks.route("/userscan", methods=['POST'])
def user_scan_qr():
	data = request.json
	qrcode = data['qrcode']
	uid = data['uid']
	if(qrcode == None or uid == None):
		return "Invalid Payload", 400
	u = User.query.filter_by(id=uid).first()
	if(u == None):
		return "Invalid User", 400
	bid, eid = qrcode.split(':') #batchid:entityid
	bat = ProductBatch.query.filter_by(id=bid).first()
	if(bat == None):
		return "Invalid Batch", 400
	ent = ProductEntity.query.filter_by(id=eid, batch=bat).first()
	if(ent == None):
		return "Invalid Entity", 400
	if(ent.disposed):
		return "Already Scanned", 400
	
	#Dispose the Entity
	ent.disposed = True

	#Award some points to user
	u.points = u.points + 10

	db.session.commit()

	return "Disposed", 200