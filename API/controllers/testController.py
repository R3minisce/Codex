from models.fileModel import File
from models.fileTopicModel import FileTopic
from models.topicModel import Topic
from flask import json, request, jsonify
from __main__ import app, db


@app.route('/dominantTopicByFile/<corpus_id>', methods=['GET'])
def get_dominant_topiuc_by_file(corpus_id):

    data = {}
    topics = Topic.query.filter_by(parent_id=corpus_id).order_by(Topic.percent.desc()).limit(3)

    for top in topics:
        data[top.id] = []

    docs = []
    [docs.append(ft.file_id) for _, ft in db.session.query(Topic, FileTopic).select_from(
         Topic).join(FileTopic).filter(Topic.id == topics[0].id, Topic.parent_id == corpus_id).all()]

    for doc in docs:
        results = db.session.query(Topic, FileTopic, File).select_from(Topic).join(FileTopic) \
            .join(File).filter(Topic.parent_id == corpus_id, File.id == doc) \
            .order_by(FileTopic.file_weight_in_topic.desc()).limit(1)

        for t, tf, f in results:
            if (t.id in data):
                temp = {}
                temp["topic_id"] = t.id
                temp["parent_id"] = t.parent_id
                temp["weight"] = t.weight
                temp["percent"] = t.percent
                temp["title"] = f.title
                temp["file_id"] = f.id
                temp["datetime"] = str(f.creationTime)[:4]
                temp["weight_in_topic"] = tf.file_weight_in_topic
                data[t.id].append(temp)

    return jsonify(data)

