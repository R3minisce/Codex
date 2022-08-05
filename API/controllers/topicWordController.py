
from models.wordModel import word_exists
from models.topicModel import topic_exists
from flask import request, jsonify
from __main__ import app, db
from models.topicWordModel import TopicWord


@app.route('/wordTopic', methods=['GET'])
def get_all_wordTopics():
    wordTopics = TopicWord.query.all()
    output = []

    for c in wordTopics:
        wordTopic_data = {}
        wordTopic_data['word_id'] = c.word_id
        wordTopic_data['id'] = c.id
        wordTopic_data['topic_id'] = c.topic_id
        wordTopic_data['weight'] = c.weight
        wordTopic_data['percent'] = c.percent

        output.append(wordTopic_data)

    return jsonify({'all words' : output})

@app.route('/wordTopic', methods=['POST'])
def create_wordTopic():
    data = request.get_json()

    if word_exists(data['word_id']) and topic_exists(data['topic_id']):
        new_wordTopic = TopicWord(word_id=data['word_id'], topic_id=data['topic_id'])
        db.session.add(new_wordTopic)

        db.session.commit()
        return jsonify({'message' : 'New association between word and topic created!'})

    return jsonify({'message' : 'word or topic not found'})

@app.route('/wordTopic/<id>', methods=['GET'])
def get_one_wordTopic(id):
    wordTopic = TopicWord.query.filter_by(id=id).first()

    if not wordTopic:
        return jsonify({'message' : 'No association between this word and this topic found!'})

    wordTopic_data = {}
    wordTopic_data['id'] = wordTopic.id
    wordTopic_data['word_id'] = wordTopic.word_id
    wordTopic_data['topic_id'] = wordTopic.topic_id

    return jsonify({'wordTopic' : wordTopic_data})


@app.route('/wordTopic/<id>', methods=['PUT'])
def update_wordTopic(id):
    wordTopic = TopicWord.query.filter_by(id=id).first()
    data = request.get_json()
    
    if not wordTopic:
        return jsonify({'message' : 'No association between this word and this topic found!'})

    if word_exists(data['word_id']) and topic_exists(data['topic_id']):
        wordTopic.word_id = data['word_id']
        wordTopic.topic_id = data['topic_id']

        db.session.commit()
        return jsonify({'message' : 'The assocition between word and topic has been updated!'})

    return jsonify({'message' : 'word or topic not found'})

@app.route('/wordTopic/<id>', methods=['DELETE'])
def delete_wordTopic(id):
    wordTopic = TopicWord.query.filter_by(id=id).first()

    if not wordTopic:
        return jsonify({'message' : 'No association between this word and this topic found!'})

    db.session.delete(wordTopic)
    db.session.commit()

    return jsonify({'message' : 'The association between this word and this topic has been deleted!'})

@app.route('/topicWordByWordId/<id>', methods=['DELETE'])
def delete_topicWord_by_word_id(id):
    topicWords = TopicWord.query.filter_by(word_id=id)

    if not topicWords:
        return jsonify({'message' : 'No association with this word found!'})

    for topicWord in topicWords:
        db.session.delete(topicWord)

    db.session.commit()

    return jsonify({'message' : 'All associations for this word has been deleted!'})


@app.route('/topicWordByTopicId/<id>', methods=['DELETE'])
def delete_topicWord_by_topic_id(id):
    topicWords = TopicWord.query.filter_by(topic_id=id)

    if not topicWords:
        return jsonify({'message' : 'No association with this topic found!'})

    for topicWord in topicWords:
        db.session.delete(topicWord)

    db.session.commit()

    return jsonify({'message' : 'All associations for this topic has been deleted!'})