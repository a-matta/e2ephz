import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from datetime import datetime, timedelta
import time

class NpsDatabase:
    def __init__(self):
        try:
            firebase_admin.get_app()
            self.db = firestore.client()
        except ValueError as e:
            cred = credentials.Certificate("serviceAccountKey.json")
            firebase_admin.initialize_app(cred, {"projectId": "promoterscore-14480"})
            self.db = firestore.client()
    
    def survey_results(self):
        pass
        ref = self.db.collection(u'survey_results')
        #docs = ref.stream()
        searchDate = datetime.today() - timedelta(days=30)
        unixtime = time.mktime(searchDate.timetuple())
        #docs = ref.stream()
        #docs = ref.where(u'choice', u'>', 9).stream()
        #docs = ref.where(u'createdAt', u'<', datetime.today()).stream()
        #docs = ref.where(u'surveyResult', u'==', 'promoter').stream()
        #docs = ref.where(u'surveyResult', u'==', 'detractor').stream()
        #docs = ref.where(u'surveyResult', u'==', 'passive').stream()
        docs = ref.where(u'choice', u'>', 9).stream()

        result = ""
        for doc in docs:
            result = result + f'{doc.id} => {doc.to_dict()}\n'
            print(doc.to_dict())
        
        # TODO
        # get current month
        # find all results from db
        # create a dictionary
        # promoters = 8
        # passive = 2
        # detractors = 11
        # current score = 30
        # last month score = 33
        return result # return the dict here


n = NpsDatabase()
#print(n.survey_results())
n.survey_results()