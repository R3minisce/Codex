from flask import request, jsonify
from __main__ import app, db
from models.corpusModel import corpus_exists
from models.fileModel import file_exists
from models.corpusFileModel import CorpusFile

@app.route('/corpusFile', methods=['GET'])
def get_all_corpusFiles():
    corpusFiles = CorpusFile.query.all()
    output = []

    for c in corpusFiles:
        corpusFile_data = {}
        corpusFile_data['id'] = c.id
        corpusFile_data['corpus_id'] = c.corpus_id
        corpusFile_data['file_id'] = c.file_id

        output.append(corpusFile_data)

    return jsonify({'corpusFiles' : output})

@app.route('/filesByCorpus/<id>', methods=['GET'])
def get_files_by_corpus_id(id):
    corpusFiles = CorpusFile.query.filter_by(corpus_id=id).all()
    output = []

    for c in corpusFiles:
        output.append(c.file_id)

    return jsonify({'filesByCorpus' : output})


@app.route('/corpusFileByCorpus/<id>', methods=['GET'])
def get_all_corpusFiles_by_corpus(id):
    corpusFiles = CorpusFile.query.filter_by(corpus_id=id).all()
    output = []

    for c in corpusFiles:
        corpusFile_data = {}
        corpusFile_data['id'] = c.id
        corpusFile_data['corpus_id'] = c.corpus_id
        corpusFile_data['file_id'] = c.file_id

        output.append(corpusFile_data)

    return jsonify({'corpusFiles by corpus' : output})


@app.route('/corpusFile', methods=['POST'])
def create_corpusFile():
    data = request.get_json()

    if corpus_exists(data['corpus_id']) and file_exists(data['file_id']):
        new_corpusFile = CorpusFile(corpus_id=data['corpus_id'], file_id=data['file_id'])
        db.session.add(new_corpusFile)
        db.session.commit()
        return jsonify({'message' : 'New association between corpus and file created!'})

    return jsonify({'message' : 'corpus or file not found'})


@app.route('/corpusFile/<id>', methods=['GET'])
def get_one_corpusFile(id):
    corpusFile = CorpusFile.query.filter_by(id=id).first()

    if not corpusFile:
        return jsonify({'message' : 'No association between this corpus and this file found!'})

    corpusFile_data = {}
    corpusFile_data['id'] = corpusFile.id
    corpusFile_data['corpus_id'] = corpusFile.corpus_id
    corpusFile_data['file_id'] = corpusFile.file_id

    return jsonify({'corpusFile' : corpusFile_data})

@app.route('/corpusFile/<id>', methods=['PUT'])
def update_corpusFile(id):
    corpusFile = CorpusFile.query.filter_by(id=id).first()
    data = request.get_json()
    
    if not corpusFile:
        return jsonify({'message' : 'No association between this corpus and this file found!'})

    if corpus_exists(data['corpus_id']) and file_exists(data['file_id']):
        corpusFile.corpus_id = data['corpus_id']
        corpusFile.file_id = data['file_id']

        db.session.commit()
        return jsonify({'message' : 'The assocition between corpus and file has been updated!'})

    return jsonify({'message' : 'corpus or file not found'})


@app.route('/corpusFile/<id>', methods=['DELETE'])
def delete_corpusFile(id):
    corpusFile = CorpusFile.query.filter_by(id=id).first()

    if not corpusFile:
        return jsonify({'message' : 'No association between this corpus and this file found!'})

    db.session.delete(corpusFile)
    db.session.commit()

    return jsonify({'message' : 'The association between this corpus and this file has been deleted!'})


@app.route('/corpusFileByCorpusId/<id>', methods=['DELETE'])
def delete_corpusFile_by_corpus_id(id):
    corpusFiles = CorpusFile.query.filter_by(corpus_id=id)

    if not corpusFiles:
        return jsonify({'message' : 'No association with this corpus found!'})

    for corpusFile in corpusFiles:
        db.session.delete(corpusFile)

    db.session.commit()

    return jsonify({'message' : 'All associations for this corpus has been deleted!'})


@app.route('/corpusFileByFileId/<id>', methods=['DELETE'])
def delete_corpusFile_by_file_id(id):
    corpusFiles = CorpusFile.query.filter_by(file_id=id)

    if not corpusFiles:
        return jsonify({'message' : 'No association with this file found!'})

    for corpusFile in corpusFiles:
        db.session.delete(corpusFile)

    db.session.commit()

    return jsonify({'message' : 'All associations for this file has been deleted!'})
