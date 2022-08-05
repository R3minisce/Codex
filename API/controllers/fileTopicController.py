from models.fileModel import File
from models.wordModel import Word
from models.topicWordModel import TopicWord
from models.fileModel import file_exists
from models.topicModel import topic_exists
from flask import request, jsonify
from __main__ import app, db
from models.fileTopicModel import FileTopic
from models.corpusFileModel import CorpusFile


@app.route('/fileTopic', methods=['GET'])
def get_all_fileTopics():
    fileTopics = FileTopic.query.all()
    output = []

    for c in fileTopics:
        fileTopic_data = {}
        fileTopic_data['id'] = c.id
        fileTopic_data['file_id'] = c.file_id
        fileTopic_data['topic_id'] = c.topic_id

        output.append(fileTopic_data)

    return jsonify({'fileTopics' : output})

@app.route('/fileTopicByTopic/<id>', methods=['GET'])
def get_all_fileTopics_by_topic(id):
    fileTopics = FileTopic.query.filter_by(topic_id=id).order_by(FileTopic.file_weight_in_topic.desc()).limit(5)
    output = []

    for c in fileTopics:
        fileTopic_data = {}
        fileTopic_data['id'] = c.id
        fileTopic_data['file_id'] = c.file_id
        fileTopic_data['topic_id'] = c.topic_id
        fileTopic_data['file_weight_in_topic'] = c.file_weight_in_topic
        file = File.query.filter_by(id=c.file_id).first()
        fileTopic_data['title'] = file.title
        fileTopic_data['creationTime'] = file.creationTime
        fileTopic_data['language'] = file.language
        fileTopic_data['nbPages'] = file.nbPages

        output.append(fileTopic_data)

    return jsonify({'fileTopics' : output})


@app.route('/allFilesInfo', methods=['GET'])
def get_all_file_infos():
    files = File.query.all()
    output = []

    for file in files:
        files_data = {}
        files_data['title'] = file.title
        files_data['id'] = file.id
        files_data['creationTime'] = file.creationTime
        files_data['language'] = file.language
        files_data['nbPages'] = file.nbPages
        files_data['is_selected'] = file.is_selected
        files_data['dominant_topics'] = []
        files_data['corpuses'] = []
        files_data['words'] = []

        corpuses = CorpusFile.query.filter_by(file_id=file.id).all()
        for c in corpuses:
            if c.corpus_id not in files_data["corpuses"]:
                files_data["corpuses"].append(c.corpus_id)

        fileTopics = FileTopic.query.filter_by(file_id=file.id).order_by(FileTopic.file_weight_in_topic.desc()).limit(2)
        for ft in fileTopics:
            files_data['dominant_topics'].append(ft.topic_id)
            topicWords = TopicWord.query.filter_by(topic_id=ft.topic_id).order_by(TopicWord.percent.desc()).limit(2)
            for w in topicWords:
                word = Word.query.filter_by(id=w.word_id).first()
                files_data['words'].append(word.name)

        output.append(files_data)

    return jsonify({'files' : output})


@app.route('/fileTopic', methods=['POST'])
def create_fileTopic():
    data = request.get_json()

    if file_exists(data['file_id']) and topic_exists(data['topic_id']):
        new_fileTopic = FileTopic(file_id=data['file_id'], topic_id=data['topic_id'])
        db.session.add(new_fileTopic)

        db.session.commit()
        return jsonify({'message' : 'New association between file and topic created!'})

    return jsonify({'message' : 'file or topic not found'})

@app.route('/fileTopic/<id>', methods=['GET'])
def get_one_fileTopic(id):
    fileTopic = FileTopic.query.filter_by(id=id).first()

    if not fileTopic:
        return jsonify({'message' : 'No association between this file and this topic found!'})

    fileTopic_data = {}
    fileTopic_data['id'] = fileTopic.id
    fileTopic_data['file_id'] = fileTopic.file_id
    fileTopic_data['topic_id'] = fileTopic.topic_id

    return jsonify({'fileTopic' : fileTopic_data})


@app.route('/fileTopic/<id>', methods=['PUT'])
def update_fileTopic(id):
    fileTopic = FileTopic.query.filter_by(id=id).first()
    data = request.get_json()
    
    if not fileTopic:
        return jsonify({'message' : 'No association between this file and this topic found!'})

    if file_exists(data['file_id']) and topic_exists(data['topic_id']):
        fileTopic.file_id = data['file_id']
        fileTopic.topic_id = data['topic_id']

        db.session.commit()
        return jsonify({'message' : 'The assocition between file and topic has been updated!'})

    return jsonify({'message' : 'file or topic not found'})

@app.route('/fileTopic/<id>', methods=['DELETE'])
def delete_fileTopic(id):
    fileTopic = FileTopic.query.filter_by(id=id).first()

    if not fileTopic:
        return jsonify({'message' : 'No association between this file and this topic found!'})

    db.session.delete(fileTopic)
    db.session.commit()

    return jsonify({'message' : 'The association between this file and this topic has been deleted!'})

@app.route('/fileTopicByFileId/<id>', methods=['DELETE'])
def delete_fileTopic_by_file_id(id):
    fileTopics = FileTopic.query.filter_by(file_id=id)

    if not fileTopics:
        return jsonify({'message' : 'No association with this file found!'})

    for fileTopic in fileTopics:
        db.session.delete(fileTopic)

    db.session.commit()

    return jsonify({'message' : 'All associations for this file has been deleted!'})


@app.route('/fileTopicByTopicId/<id>', methods=['DELETE'])
def delete_fileTopic_by_topic_id(id):
    fileTopics = FileTopic.query.filter_by(topic_id=id)

    if not fileTopics:
        return jsonify({'message' : 'No association with this topic found!'})

    for fileTopic in fileTopics:
        db.session.delete(fileTopic)

    db.session.commit()

    return jsonify({'message' : 'All associations for this topic has been deleted!'})