import nltk
import numpy as np
from nltk.stem.porter import PorterStemmer
stemmer=PorterStemmer()


#la technique de tokenization sert à éclater les mots d'une phrase dans un tableau
def tokenize(sentence):
    return nltk.word_tokenize(sentence)


#la technique de stemming sert à éliminer les terminaison du genre ("ing","er" etc...) 
def stem(word):
    return stemmer.stem(word.lower())


#la technique bag of words exp :
"""
  phrase = #["hello", "how", "are", "you"]
    liste_des_mots = #["hi", "hello", "I", "you", "bye", "thank", "cool"]
    bag_of_words   = [  0 ,    1 ,    0 ,   1 ,    0 ,    0 ,      0]
"""
def bag_of_words(tokenized_sentence,words):
    # Appliquer le "stemming" pour chaque mot
    sentence_words = [stem(word) for word in tokenized_sentence]
    # initialisation du tableau par des 0
    bag = np.zeros(len(words), dtype=np.float32)
    for i, mot in enumerate(words):
        if mot in sentence_words: 
            bag[i] = 1

    return bag

