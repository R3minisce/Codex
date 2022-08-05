from sqlalchemy import Column, Integer, Float
from __main__ import db

class Topic(db.Model):
    __tablename__ = 'topic'
    id = Column(Integer, primary_key=True)
    #name = Column(String(50))
    weight = Column(Float)
    percent = Column(Float)
    parent_id = Column(Integer)


def topic_exists(id):
    topic = Topic.query.filter_by(id=id).first()

    if not topic:
        return False
    return True