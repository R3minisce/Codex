from models.wordModel import word_exists
from models.fileModel import file_exists
from flask import request, jsonify
from __main__ import app, db
from models.fileWordModel import FileWord


@app.route('/fileWord', methods=['GET'])
def get_all_fileWords():
    fileWords = FileWord.query.all()
    output = []

    for f in fileWords:
        fileWord_data = {}
        fileWord_data['word_id'] = f.word_id
        fileWord_data['id'] = f.id
        fileWord_data['file_id'] = f.topic_id

        output.append(fileWord_data)

    return jsonify({'fileWords' : output})