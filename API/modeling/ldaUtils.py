from controllers.topicController import delete_topics_by_corpus
from models.wordModel import word_exists
from models.fileTopicModel import FileTopic
from models.corpusFileModel import CorpusFile
from models.topicWordModel import TopicWord
from models.wordModel import Word
from models.topicModel import Topic
from controllers.corpusController import get_one_corpus
from models.corpusModel import Corpus
import pandas as pd
import numpy
from __main__ import app, db
from flask import jsonify
from controllers.corpusFileController import get_files_by_corpus_id
from controllers.fileController import get_one_file
import dill

from sklearn.decomposition import LatentDirichletAllocation
from sklearn.feature_extraction.text import CountVectorizer

N_FEATURES = 1000
N_COMPONENTS = 10
N_TOP_WORDS = 10

@app.route('/analyseCorpus/<id>', methods=['GET'])
def analyseCorpus(id):
    init_lda(id)
    if Topic.query.filter_by(parent_id=id).all() is not None: 
        delete_topics_by_corpus(id)
    get_top_words_by_corpus(id)
    get_best_topic_by_corpus(id)
    get_best_document_for_topic_by_corpus(id)

    return jsonify({'message': 'Corpus analyse CHECK'})

@app.route('/initLDACorpus/<id>', methods=['GET'])
def init_lda(id):

    # Récupère les id des fichiers de ce corpus_id
    data = get_files_by_corpus_id(id)
    file_ids = data.json['filesByCorpus']
    
    # Préparation du dataFrame
    dataframe = []
    for item in file_ids:
        data = get_one_file(item)
        data = data.json['file']
        [data.pop(key) for key in ["creationTime",
                                   "fileType", "language", "nbPages", "title", "id"]]

        dataframe.append(data["body"])

    data = pd.Series(dataframe, index=file_ids)

    # Traitement des fichiers
    tf_vectorizer = CountVectorizer(max_df=0.95, min_df=2,
                                    max_features=N_FEATURES,
                                    stop_words='english')

    tf = tf_vectorizer.fit_transform(data)
    lda = LatentDirichletAllocation(n_components=N_COMPONENTS, max_iter=5,
                                    learning_method='online',
                                    learning_offset=50.,
                                    random_state=0)
    lda.fit(tf)
    doc_topic = lda.transform(tf)
    feature_names = tf_vectorizer.get_feature_names()

    # Création du set de données à sauvegarder
    components = []
    components.extend((feature_names, doc_topic, lda.components_))
    enc_comps = encode_corpus_data(components)

    # Update corpus
    corpus = Corpus.query.filter_by(id=id).first()
    corpus.features_name = enc_comps[0]
    corpus.doc_topic = enc_comps[1]
    corpus.lda = enc_comps[2]
    db.session.commit()

    return jsonify({'message': 'init_lda CHECK'})


@app.route('/topWordsByTopic/<id>', methods=['GET'])
def get_top_words_by_corpus(id):

    enc_comps = []

    # Get corpus + récupération des données nécessaires (lda_comps, features_names)
    corpus = Corpus.query.filter_by(id=id).first()
    enc_comps.append(corpus.features_name)
    enc_comps.append(corpus.lda)
    components = decode_corpus_data(enc_comps)
    lda_components = components[1]
    feature_names = components[0]

    # Récupère les id des fichiers de ce corpus_id
    data = get_files_by_corpus_id(id)
    file_ids = data.json['filesByCorpus']


    # On parcourt les comps
    for _, topic in enumerate(lda_components):
        top_features_ind = topic.argsort()[:-N_TOP_WORDS - 1:-1]
        top_features = [feature_names[i] for i in top_features_ind]
        weights = topic[top_features_ind]
        topic_weight = sum(weights)
        percent = [(item / topic_weight) * 100 for item in weights]
        word_list = list(zip(top_features, weights, percent))

        # Ajout des mots et poids à chaque topic

        # Créer le topic en DB
        new_topic = Topic(weight=topic_weight, parent_id=id)
        db.session.add(new_topic)
        db.session.commit()
        db.session.refresh(new_topic)

        # Créer chaque mot en DB et association
        for dataset in word_list:
            
            word_id = word_exists(dataset[0])

            if word_id == 0:

                # Création du mot
                new_word = Word(name=dataset[0])
                db.session.add(new_word)
                db.session.commit()
                db.session.refresh(new_word)
                word_id = new_word.id

            # Création de l'association
            new_wordTopic = TopicWord(
                topic_id=new_topic.id, word_id=word_id, weight=dataset[1], percent=dataset[2])
            db.session.add(new_wordTopic)
            db.session.commit()

    return jsonify({'message': 'get_top_words_by_corpus CHECK'})


@app.route('/bestTopicByCorpus/<id>', methods=['GET'])
def get_best_topic_by_corpus(id):

    # Récupération des topics d'un corpus
    all_topic_weights = []
    topics = Topic.query.filter_by(parent_id=id).all()
    [all_topic_weights.append(topic.weight) for topic in topics]

    # Calcul du pourcentage des topics
    for topic in topics:
        topic.percent = (topic.weight / sum(all_topic_weights)) * 100
        db.session.commit()

    # Topic au poids le plus élévé
    index = all_topic_weights.index(max(all_topic_weights))
    topic_id = topics[index].id

    # Ajout en DB
    corpus = Corpus.query.filter_by(id=id).first()
    corpus.best_topic = topic_id
    db.session.commit()

    return jsonify({'message': 'get_best_topic_by_corpus CHECK'})


@app.route('/bestDocForTopicByCorpus/<id>', methods=['GET'])
def get_best_document_for_topic_by_corpus(id):

    # Récupération des topics
    topics = Topic.query.filter_by(parent_id=id).all()

    # Récupération du corpus doc_topic
    corpus = Corpus.query.filter_by(id=id).first()
    enc_comps = [corpus.doc_topic]
    components = decode_corpus_data(enc_comps)
    doc_topic = components[0]

    # Récupération de tous les corpus_file
    corpusFiles = CorpusFile.query.filter_by(corpus_id=id).all()

    # Parcours des topics
    for topic in topics:
        index = topics.index(topic)
        max_doc_topic = []

        # Parcours des données d'un topic
        doc_index = 0
        for item in doc_topic:
            #print("Poids du document ", corpusFiles[doc_index].file_id, " : " , item[index], " pour le topic ", topics[index].id)
            new_fileTopic = FileTopic(
                file_id=corpusFiles[doc_index].file_id, topic_id=topics[index].id, file_weight_in_topic=item[index])
            db.session.add(new_fileTopic)
            db.session.commit()
            doc_index += 1

    return jsonify({'message': 'get_best_document_for_topic_by_corpus CHECK'})


def get_word_occurence_by_doc(data):
    # Si nécessité de trouver le nombre d'occurence dans un même document
    nb_carac = 500
    doc = 2
    print("Les ", str(nb_carac), "du document", str(
        doc), ": \n",  data.iloc[doc][0:nb_carac])


def encode_corpus_data(components):
    return [dill.dumps(item) for item in components]


def decode_corpus_data(enc_comps):
    return [numpy.loads(item) for item in enc_comps]
