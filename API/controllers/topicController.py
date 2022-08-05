from flask import request, jsonify
from __main__ import app, db
from .topicWordController import delete_topicWord_by_topic_id
from .fileTopicController import delete_fileTopic_by_topic_id
from models.topicModel import Topic

@app.route('/topic', methods=['GET'])
def get_all_topics():
    topics = Topic.query.all()
    output = []

    for topic in topics:
        topic_data = {}
        topic_data['id'] = topic.id
        topic_data['weight'] = topic.weight
        topic_data['percent'] = topic.percent
        output.append(topic_data)

    return jsonify({'topics' : output})


@app.route('/topic', methods=['POST'])
def create_topic():
    data = request.get_json()
    new_topic = Topic(name=data['name'], weight=data['weight'])
    db.session.add(new_topic)
    db.session.commit()

    return jsonify({'message' : 'New topic created!'})


@app.route('/topic/<id>', methods=['GET'])
def get_one_topic(id):
    topic = Topic.query.filter_by(id=id).first()

    if not topic:
        return jsonify({'message' : 'No topic found!'})

    topic_data = {}
    topic_data['id'] = topic.id
    topic_data['weight'] = topic.weight
    topic_data['percent'] = topic.percent
    topic_data['parent_id'] = topic.parent_id

    return jsonify({'topic' : topic_data})

@app.route('/topicByCorpus/<id>', methods=['GET'])
def get_all_topic_by_corpus(id):
    output = []
    topics = Topic.query.filter_by(parent_id=id).all()

    if not topics:
        return jsonify({'message' : 'No topic found!'})

    for topic in topics:
        topic_data = {}
        topic_data['id'] = topic.id
        topic_data['weight'] = topic.weight
        topic_data['percent'] = topic.percent
        topic_data['parent_id'] = topic.parent_id
        output.append(topic_data)

    return jsonify({'topics by corpus' : output})


@app.route('/topic/<id>', methods=['PUT'])
def update_topic(id):
    topic = Topic.query.filter_by(id=id).first()
    data = request.get_json()
    
    if not topic:
        return jsonify({'message' : 'No topic found!'})

    topic.weight = data['weight']
    topic.percent = data['percent']

    db.session.commit()

    return jsonify({'message' : 'The user has been updated!'})


@app.route('/topic/<id>', methods=['DELETE'])
def delete_topic(id):
    topic = Topic.query.filter_by(id=id).first()

    if not topic:
        return jsonify({'message' : 'No topic found!'})
        
    delete_topicWord_by_topic_id(id)
    delete_fileTopic_by_topic_id(id)
    
    db.session.delete(topic)
    db.session.commit()

    return jsonify({'message' : 'The topic has been deleted!'})

@app.route('/topicsByCorpus/<id>', methods=['DELETE'])
def delete_topics_by_corpus(id):
    topics = Topic.query.filter_by(parent_id=id).all()

    for topic in topics:

        if not topic:
            return jsonify({'message' : 'No topic found!'})
            
        delete_topicWord_by_topic_id(topic.id)
        delete_fileTopic_by_topic_id(topic.id)
        
        db.session.delete(topic)
        db.session.commit()

    return jsonify({'message' : 'The topic has been deleted!'})

