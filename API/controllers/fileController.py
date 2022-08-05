from flask import request, jsonify
from __main__ import app, db
from .corpusFileController import delete_corpusFile_by_file_id
from .fileTopicController import delete_fileTopic_by_file_id
from models.fileModel import File


@app.route('/file', methods=['GET'])
def get_all_files():
    files = File.query.all()
    output = []

    for f in files:
        file_data = {}
        file_data['id'] = f.id
        file_data['title'] = f.title
        #file_data['author'] = f.author
        file_data['language'] = f.language
        file_data['fileType'] = f.fileType
        file_data['creationTime'] = f.creationTime
        file_data['nbPages'] = f.nbPages
        #file_data['fileSize'] = f.fileSize
        file_data['body'] = ""
        file_data['is_selected'] = f.is_selected

        output.append(file_data)

    return jsonify({'files': output})

@app.route('/fileSelectionReset', methods=['GET'])
def reset_selected_files():
    files = File.query.filter_by(is_selected=True).all()

    for f in files:
        f.is_selected = False

    db.session.commit()

    return jsonify({'message': 'reset selected file CHECK'})

@app.route('/listSelectionReset', methods=['PUT'])
def toogle_selected_list():
    data = request.get_json()

    for f in data["files"]:
        file = File.query.filter_by(id=f).first()
        file.is_selected = not file.is_selected

    db.session.commit()

    return jsonify({'message': 'reset selected file CHECK'})

@app.route('/selectedFiles', methods=['GET'])
def get_selected_files():
    files = File.query.filter_by(is_selected=True).all()
    output = []

    for f in files:
        output.append(f.id)

    return jsonify({'selected Files': output})

@app.route('/toogleFileSelection/<id>', methods=['GET'])
def select_file(id):
    file = File.query.filter_by(id=id).first()
    
    if not file:
        return jsonify({'message' : 'No file found!'})

    file.is_selected = not file.is_selected

    db.session.commit()

    return jsonify({'message' : 'File toogle selection'})

@app.route('/file', methods=['POST'])
def create_file():
    data = request.get_json()
    new_file = File(title=data['title'], language=data['language'],
                    fileType=data['fileType'], creationTime=data['creationTime'], nbPages=data['nbPages'], body=data['body'], is_selected=False)
    db.session.add(new_file)
    db.session.commit()
    db.session.refresh(new_file)

    return jsonify({'message' : 'New file created!', 'id': new_file.id})

@app.route('/file/<id>', methods=['GET'])
def get_one_file(id):
    f = File.query.filter_by(id=id).first()

    if not f:
        return jsonify({'message': 'No file found!'})

    file_data = {}
    file_data['id'] = f.id
    file_data['title'] = f.title
    #file_data['author'] = f.author
    file_data['language'] = f.language
    file_data['fileType'] = f.fileType
    file_data['creationTime'] = f.creationTime
    file_data['nbPages'] = f.nbPages
    #file_data['fileSize'] = f.fileSize
    file_data['body'] = f.body

    return jsonify({'file': file_data})

@app.route('/file/<id>', methods=['PUT'])
def update_file(id):
    f = File.query.filter_by(id=id).first()
    data = request.get_json()

    if not f:
        return jsonify({'message': 'No file found!'})

    f.title = data['title']
    #f.author = data['author']
    f.language = data['language']
    f.fileType = data['fileType']
    f.creationTime = data['creationTime']
    f.nbPages = data['nbPages']
    #f.fileSize = data['fileSize']
    f.body = data['body']

    db.session.commit()

    return jsonify({'message': 'The file has been updated!'})

@app.route('/file/<id>', methods=['DELETE'])
def delete_file(id):
    f = File.query.filter_by(id=id).first()

    if not f:
        return jsonify({'message': 'No file found!'})

    delete_corpusFile_by_file_id(id)
    delete_fileTopic_by_file_id(id)

    db.session.delete(f)
    db.session.commit()

    return jsonify({'message': 'The file has been deleted!'})
