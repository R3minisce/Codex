from sqlalchemy import Column, Integer, String, Float
from __main__ import db

class Word(db.Model):
    id = Column(Integer, primary_key=True)
    name = Column(String(50))

def word_exists(word):
    word = Word.query.filter_by(name=word).first()

    if not word:
        return 0
    return word.id