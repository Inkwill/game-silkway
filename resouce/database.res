{
    "event": {

        "id" : {"data_type":"int", "primary_key": true, "not_null": true, "AUTOINCREMENT":true},
        "pattern":{"data_type":"text","not_null": true},
        "subject": {"data_type":"text", "not_null": true},
        "predicate": {"data_type":"text", "not_null": true},
        "object":{"data_type":"text"},
        "date":{"data_type":"int","not_null": true}
    },
     "actor": {

        "id" : {"data_type":"int", "primary_key": true, "not_null": true,"AUTOINCREMENT":true},
        "form": {"data_type":"text", "not_null": true},
        "name": {"data_type":"text"},
        "ownerid" : {"data_type":"int","foreign_key":"actor.id"},
        "posx" : {"data_type":"float"},
        "posy" : {"data_type":"float"},
        "createdate" : {"data_type":"int","not_null": true},
        "perishdate" : {"data_type":"int"},
        "history" : {"data_type":"text"},
        "assetid":  {"data_type":"int","foreign_key":"asset.id"},
	    "actions": {"data_type":"text"}
    },
    "asset": {
         "id" : {"data_type":"int", "primary_key": true, "not_null": true,"AUTOINCREMENT":true},
         "form": {"data_type":"text", "not_null": true},
         "ownerid" : {"data_type":"int","foreign_key":"actor.id"},
         "posx" : {"data_type":"float"},
         "posy" : {"data_type":"float"},
         "createdate" : {"data_type":"int","not_null": true},
         "perishdate" : {"data_type":"int"},
         "coin" : {"data_type":"int"},
         "silver" : {"data_type":"int"},
         "gold" : {"data_type":"int"}
    },
    "aero": {
         "id" : {"data_type":"int", "primary_key": true, "not_null": true},
         "form": {"data_type":"text", "not_null": true},
         "ownerid" : {"data_type":"int","foreign_key":"actor.id"},
         "posx" : {"data_type":"int"},
         "posy" : {"data_type":"int"},
         "createdate" : {"data_type":"int","not_null": true},
         "perishdate" : {"data_type":"int"},
         "population" : {"data_type":"int"},
         "cells" : { "data_type":"text"}
    }
}
