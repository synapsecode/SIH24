import os
basedir = os.path.abspath(os.path.dirname(__file__))


# DBURI = 'postgresql://postgres.mjtumksaydbsmqewlpeh:DT0gTtvHAkVVXMIM@aws-0-us-east-1.pooler.supabase.com:6543/postgres'
DBURI = 'postgresql://postgres.dwpfhlgctzbxtgstxbqm:4MaUGpyo0cw20eWi@aws-0-ap-south-1.pooler.supabase.com:6543/postgres'

class Config:
	SECRET_KEY = "2F5F6CE5AE30B54AA5D7CED1BA566982BAB34BA2814A51CE1865D2C2D8815CD4"
	# SQLALCHEMY_DATABASE_URI = 'sqlite:///' + os.path.join(basedir, 'db.sqlite') #Database path
	SQLALCHEMY_DATABASE_URI = DBURI
	SQLALCHEMY_TRACK_MODIFICATIONS = False
	PRODUCTION_MODE = True #This states whether the app runs in DEBUG MODE or not
	PORT_NUMBER = 8080
	HOST_NAME = 'localhost'
	UPLOAD_FOLDER = 'static'
