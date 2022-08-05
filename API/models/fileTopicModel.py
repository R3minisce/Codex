from sqlalchemy import Column, Integer, ForeignKey, Float
from __main__ import db

# File Topic
class FileTopic(db.Model):
    id = Column(Integer, primary_key=True)
    file_id = Column(Integer, ForeignKey('file.id'))
    topic_id = Column(Integer, ForeignKey('topic.id'))
    file_weight_in_topic = Column(Float)