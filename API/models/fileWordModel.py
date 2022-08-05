from sqlalchemy import Column, Integer, ForeignKey
from __main__ import db


class FileWord(db.Model):
    __tablename__ = 'file_word'
    id = Column(Integer, primary_key=True)
    file_id = Column(Integer, ForeignKey('file.id'))
    word_id = Column(Integer, ForeignKey('word.id'))