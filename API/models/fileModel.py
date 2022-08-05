from sqlalchemy import Column, Integer, String, Boolean
from __main__ import db

from sqlalchemy.sql.sqltypes import DateTime

class File(db.Model):
    id = Column(Integer, primary_key=True)
    title = Column(String(255))
    # author = Column(String(50))
    language = Column(String(20))
    nbPages = Column(Integer)
    fileType = Column(String(20))
    creationTime = Column(DateTime)
    # fileSize = Column(Float)
    body = Column(db.Text(10000000))
    is_selected = Column(Boolean)

def file_exists(id):
    f = File.query.filter_by(id=id).first()

    if not f:
        return False
    return True