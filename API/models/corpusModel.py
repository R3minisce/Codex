from sqlalchemy import Column, Integer, String, LargeBinary, Boolean
from __main__ import db

class Corpus(db.Model):
    __tablename__ = 'corpus'
    id = Column(Integer, primary_key=True)
    name = Column(String(50))
    nbFile = Column(Integer)
    features_name = Column(LargeBinary(length=1000000))
    doc_topic = Column(LargeBinary(length=1000000))
    lda = Column(LargeBinary(length=1000000))
    best_topic = Column(Integer)
    is_selected = Column(Boolean)

def corpus_exists(id):
    corpus = Corpus.query.filter_by(id=id).first()

    if not corpus:
        return False
    return True