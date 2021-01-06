{
    "action": {

        "id" : {"data_type":"int", "primary_key": true, "not_null": true, "AUTOINCREMENT":true},
        "name": {"data_type":"text", "not_null": true},
    },
     "gameobj": {

        "id" : {"data_type":"int", "primary_key": true, "not_null": true,"AUTOINCREMENT":true},
        "type": {"data_type":"text", "not_null": true},
        "name": {"data_type":"text"},
        "owner": {"data_type":"int","foreign_key":"gameobj.id"},
        "asset":  {"data_type":"int","foreign_key":"assets.id"},
    },
    "assets": {
         "id" : {"data_type":"int", "primary_key": true, "not_null": true,"AUTOINCREMENT":true},
         "owner" : {"data_type":"int","foreign_key":"gameobj.id"},
         "coin" : {"data_type":"int"},
         "silver" : {"data_type":"int"},
         "gold" : {"data_type":"int"}
    }
}
