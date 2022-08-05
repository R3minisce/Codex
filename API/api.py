from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import create_engine
from flask_cors import CORS
from werkzeug.serving import WSGIRequestHandler

app = Flask(__name__)
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:root@localhost/'
db = SQLAlchemy(app)

import controllers

import modeling.ldaUtils
import modeling.importData
import controllers.corpusController
import controllers.fileController
import controllers.topicController
import controllers.wordController
import controllers.corpusFileController
import controllers.fileTopicController
import controllers.topicWordController
import controllers.fileWordController
import controllers.fileWordController
import controllers.testController

# Init new DB at launch
engine = create_engine(app.config['SQLALCHEMY_DATABASE_URI'])
engine.execute('CREATE SCHEMA IF NOT EXISTS codex')
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+mysqldb://root:root@localhost/codex'

db.create_all()

if __name__ == '__main__':
    WSGIRequestHandler.protocol_version = "HTTP/1.1"
    app.run(debug=True, host="0.0.0.0", threaded=True)