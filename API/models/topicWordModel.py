from sqlalchemy import Column, Integer, ForeignKey, Float
from __main__ import db


class TopicWord(db.Model):
    id = Column(Integer, primary_key=True)
    word_id = Column(Integer, ForeignKey('word.id'))
    topic_id = Column(Integer, ForeignKey('topic.id'))
    weight = Column(Float)
    percent = Column(Float)