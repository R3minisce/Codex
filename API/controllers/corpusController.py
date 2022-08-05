from models.corpusFileModel import CorpusFile
from flask import json, request, jsonify
from __main__ import app, db
from .corpusFileController import delete_corpusFile_by_corpus_id
from models.corpusModel import Corpus

@app.route('/corpus', methods=['GET'])
def get_all_corpuses():
    corpuses = Corpus.query.all()
    output = []

    for c in corpuses:
        corpus_data = {}
        corpus_data['id'] = c.id
        corpus_data['name'] = c.name
        corpus_data['nbFile'] = c.nbFile
        corpus_data['best_topic'] = c.best_topic
        corpus_data['is_selected'] = c.is_selected

        output.append(corpus_data)

    return jsonify({'corpuses' : output})


@app.route('/corpus', methods=['POST'])
def create_corpus():
    data = request.get_json()
    new_corpus = Corpus(name=data['name'], nbFile=len(data['fileIDs']), is_selected=False, best_topic=0)
    db.session.add(new_corpus)
    db.session.commit()
    db.session.refresh(new_corpus)

    for id in data['fileIDs']:
        # Création de l'association en DB
        new_corpusFile = CorpusFile(corpus_id=new_corpus.id, file_id=id)
        db.session.add(new_corpusFile)
        db.session.commit()
        db.session.refresh(new_corpusFile)

    return jsonify({'message' : 'New corpus created!', 'id': new_corpus.id})


@app.route('/corpus', methods=['PUT'])
def update_corpus():
    data = request.get_json()
    corpus_id = data['id']
    corpus = Corpus.query.filter_by(id=corpus_id).first()
    corpus.name = data['name']
    corpus.nbFile = len(data['fileIDs'])
    corpus.is_selected = False
    corpus.best_topic = 0
    db.session.commit()

    delete_corpusFile_by_corpus_id(corpus_id)

    for id in data['fileIDs']:
        # Création de l'association en DB
        new_corpusFile = CorpusFile(corpus_id=corpus_id, file_id=id)
        db.session.add(new_corpusFile)
        db.session.commit()
        db.session.refresh(new_corpusFile)

    return jsonify({'message' : 'corpus updated!', 'id': corpus_id})

@app.route('/corpus/<id>', methods=['GET'])
def get_one_corpus(id):
    corpus = Corpus.query.filter_by(id=id).first()

    if not corpus:
        return jsonify({'message' : 'No corpus found!'})

    corpus_data = {}
    corpus_data['id'] = corpus.id
    corpus_data['name'] = corpus.name
    corpus_data['nbFile'] = corpus.nbFile
    corpus_data['is_selected'] = corpus.is_selected
    # corpus_data['features_name'] = corpus.features_name
    # corpus_data['doc_topic'] = corpus.doc_topic
    # corpus_data['lda'] = corpus.lda

    return jsonify({'corpus' : corpus_data})


# @app.route('/corpus/<id>', methods=['PUT'])
# def update_corpus(id):
#     corpus = Corpus.query.filter_by(id=id).first()
#     data = request.get_json()
    
#     if not corpus:
#         return jsonify({'message' : 'No corpus found!'})

#     corpus.name = data['name']
#     corpus.nbFile = data['nbFile']

#     db.session.commit()

#     return jsonify({'message' : 'The corpus has been updated!'})

@app.route('/toogleCorpusSelection/<id>', methods=['PUT'])
def select_corpus(id):
    corpus = Corpus.query.filter_by(id=id).first()
    
    if not corpus:
        return jsonify({'message' : 'No corpus found!'})

    corpus.is_selected = not corpus.is_selected

    db.session.commit()

    return jsonify({'message' : 'Corpus toogle selection'})


@app.route('/corpus/<id>', methods=['DELETE'])
def delete_corpus(id):
    corpus = Corpus.query.filter_by(id=id).first()

    if not corpus:
        return jsonify({'message' : 'No corpus found!'})

    delete_corpusFile_by_corpus_id(id)

    db.session.delete(corpus)
    db.session.commit()

    return jsonify({'message' : 'The corpus has been deleted!'})

