# Les imports pour les request et Json
from models.corpusFileModel import CorpusFile
from models.fileModel import File
from models.corpusModel import Corpus
import pandas as pd
from datetime import datetime
from __main__ import db, app
from flask import jsonify

@app.route('/import', methods=['GET'])
def data_import():

    # Ouvrir le fichier et lire les lignes en partant de ...
    df = pd.read_excel(r'API\modeling\data.xlsx', 'Feuil1')
    df = df[df['language']=='EN']
    #df = df[df['language']=='EN'][1200:1400]

    ## Création du corpus
    # new_corpus = Corpus(name="corpusUltime", nbFile=len(df))
    # db.session.add(new_corpus)
    # db.session.commit()
    # db.session.refresh(new_corpus)
    # corpus_id = new_corpus.id

    # Charger les données dans une structure
    for _, row in df.iterrows():
        name = str(row['file_name'])
        fileType = str(row['file_type'])
        creationTime = str(datetime.fromtimestamp(row['creation_time']))
        # fileSize = row['file_size']
        nbPages = row['n_pages']
        language = str(row['language'])
        body = row['without_stop_words']

        # Création du fichier en DB
        new_file = File(title=name, language=language,
                    fileType=fileType, creationTime=creationTime, nbPages=nbPages, body=body, is_selected=False)
        db.session.add(new_file)
        db.session.commit()
        # db.session.refresh(new_file)
        # file_id = new_file.id

        # # Création de l'association en DB
        # new_corpusFile = CorpusFile(corpus_id=corpus_id, file_id=file_id)
        # db.session.add(new_corpusFile)
        # db.session.commit()

    return jsonify({'message': 'import CHECK'})


