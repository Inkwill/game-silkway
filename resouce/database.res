{
    "action": {

        "id" : {"data_type":"int", "primary_key": true, "not_null": true, "AUTOINCREMENT":true},
        "name": {"data_type":"text", "not_null": true},
    },
     "actor": {

        "id" : {"data_type":"int", "primary_key": true, "not_null": true,"AUTOINCREMENT":true},
        "form": {"data_type":"text", "not_null": true},
        "name": {"data_type":"text"},
        "ownerid" : {"data_type":"int","foreign_key":"actor.id"},
        "assetid":  {"data_type":"int","foreign_key":"asset.id"},
	    "aeroid": {"data_type":"int","foreign_key":"aero.id"}
    },
    "asset": {
         "id" : {"data_type":"int", "primary_key": true, "not_null": true,"AUTOINCREMENT":true},
         "ownerid" : {"data_type":"int","foreign_key":"actor.id"},
         "coin" : {"data_type":"int"},
         "silver" : {"data_type":"int"},
         "gold" : {"data_type":"int"}
    },
    "aero": {
         "id" : {"data_type":"int", "primary_key": true, "not_null": true,"AUTOINCREMENT":true},
         "ownerid" : {"data_type":"int","foreign_key":"actor.id"},
         "posid" : {"data_type":"int"},
         "population" : {"data_type":"int"}
    }
}
