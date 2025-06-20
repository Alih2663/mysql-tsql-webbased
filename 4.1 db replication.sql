-- Distributor
EXEC sp_helpdistributor;
EXEC sp_replmonitorhelpsubscription @publication_type = 0; -- 0 for transactional

USE BikeStores;
EXEC sp_helppublication;
EXEC sp_replmonitorhelppublication;

USE BikeStores_Sub; -- subscription database
EXEC sp_helpsubscription;