from models.topicWordModel import TopicWord
from flask import request, jsonify
from __main__ import app, db
from .topicWordController import delete_topicWord_by_word_id
from models.wordModel import Word


@app.route('/word', methods=['GET'])
def get_all_words():
    words = Word.query.all()
    output = []

    for word in words:
        word_data = {}
        word_data['id'] = word.id
        word_data['name'] = word.name
        word_data['weight'] = word.weight
        output.append(word_data)

    return jsonify({'words' : output})

@app.route('/wordsByTopic/<id>', methods=['GET'])
def get_all_word_by_topics(id):
    wordTopics = TopicWord.query.filter_by(topic_id=id).all()
    output = []

    if not wordTopics:
        return jsonify({'message' : 'No word found!'})

    for c in wordTopics:
        wordTopic_data = {}
        wordTopic_data['word_id'] = c.word_id
        wordTopic_data['id'] = c.id
        wordTopic_data['topic_id'] = c.topic_id
        wordTopic_data['weight'] = c.weight
        wordTopic_data['percent'] = c.percent
        wordTopic_data['word'] = Word.query.filter_by(id=c.word_id).first().name

        output.append(wordTopic_data)

    return jsonify({'words by topic' : output})

@app.route('/word', methods=['POST'])
def create_word():
    data = request.get_json()
    new_word = Word(name=data['name'], weight=data['weight'])
    db.session.add(new_word)
    db.session.commit()

    return jsonify({'message' : 'New word created!'})


@app.route('/word/<id>', methods=['GET'])
def get_one_word(id):
    word = Word.query.filter_by(id=id).first()

    if not word:
        return jsonify({'message' : 'No word found!'})

    word_data = {}
    word_data['id'] = word.id
    word_data['name'] = word.name

    return jsonify({'word' : word_data})


@app.route('/word/<id>', methods=['PUT'])
def update_word(id):
    word = Word.query.filter_by(id=id).first()
    data = request.get_json()
    
    if not word:
        return jsonify({'message' : 'No word found!'})

    word.name = data['name']

    db.session.commit()

    return jsonify({'message' : 'The user has been updated!'})


@app.route('/word/<id>', methods=['DELETE'])
def delete_word(id):
    word = Word.query.filter_by(id=id).first()

    if not word:
        return jsonify({'message' : 'No word found!'})

    delete_topicWord_by_word_id(id)

    db.session.delete(word)
    db.session.commit()

    return jsonify({'message' : 'The word has been deleted!'})

