from sqlalchemy import Column, Integer, ForeignKey
from __main__ import db

class CorpusFile(db.Model):
    id = Column(Integer, primary_key=True)
    corpus_id = Column(Integer, ForeignKey('corpus.id'))
    file_id = Column(Integer, ForeignKey('file.id'))