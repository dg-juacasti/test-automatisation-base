package com.pichincha.database;


import com.mongodb.ConnectionString;
import com.mongodb.MongoClientSettings;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.CreateCollectionOptions;
import com.mongodb.client.model.ValidationOptions;
import org.bson.codecs.configuration.CodecRegistry;
import org.bson.codecs.pojo.PojoCodecProvider;
import org.stringtemplate.v4.ST;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import static org.bson.codecs.configuration.CodecRegistries.fromProviders;
import static org.bson.codecs.configuration.CodecRegistries.fromRegistries;

public class MongoUtils {

    private static final Logger logger = Logger.getLogger(MongoUtils.class.getName());

    private MongoClient mongoClient;
    private Map<String, Object> config;
    private MongoDatabase database;

    public MongoUtils(Map<String, Object> config) {
        this.config = config;
        MongoClientSettings clientSettings;
        if(((String)config.get("username")).isEmpty() || ((String)config.get("password")).isEmpty()
        || ((String) config.get("url")).isEmpty()){
            throw new IllegalArgumentException("Nombre de Usuario o Password son nulos o vacios");
        }else{
            clientSettings = getClientSetting(getMongoUrlString(),MongoUtils.getCodec());
        }

        this.mongoClient = MongoClients.create(clientSettings);
        this.database = mongoClient.getDatabase((String)config.get("database"));
        logger.log(Level.INFO, "mongo connection ready");
    }

    public MongoClientSettings getClientSetting(String connString, CodecRegistry codecRegistry ) {

        ConnectionString connectionString = new ConnectionString(connString);
        return MongoClientSettings.builder()
                .applyConnectionString(connectionString)
                .codecRegistry(codecRegistry)
                .build();
    }

    private static CodecRegistry getCodec(){
        CodecRegistry pojoCodecRegistry = fromProviders(PojoCodecProvider.builder().automatic(true).build());
        return fromRegistries(MongoClientSettings.getDefaultCodecRegistry(),
                pojoCodecRegistry);
    }
    public String getMongoUrlString() {
        String connectionString;
        String encodedUserName = URLEncoder.encode((String) config.get("username"), StandardCharsets.UTF_8);
        String encodedPassword = URLEncoder.encode((String) config.get("password"), StandardCharsets.UTF_8);
        String userinfo = encodedUserName.concat(":").concat(encodedPassword);
        ST stMongoUrl = new ST((String) config.get("url"),'{','}');
        stMongoUrl.add("userinfo",userinfo);
        connectionString = stMongoUrl.render();
        return connectionString;
    }

    public <T> MongoCollection<T> getCollection(String collectionName, Class<T> documentClass){
        return database.getCollection(collectionName,documentClass);
    }

    public void createCollection(String collectioName, ValidationOptions options){
        database.createCollection(collectioName,
                new CreateCollectionOptions().validationOptions(options));
    }

    public void createCollection(String collectioName){
        database.createCollection(collectioName);
    }

}
