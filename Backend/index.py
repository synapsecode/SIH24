import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))


from Backend import create_app
from Backend.config import Config
import socket

socket.setdefaulttimeout(120)
app = create_app()
config = Config()
if __name__ == '__main__':
	app.run(debug=True, host=config.HOST_NAME, port=config.PORT_NUMBER)