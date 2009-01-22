/*
 * Config.fx
 *
 * Created on 8-nov-2008, 21:05:11
 */

package tweetbox.valueobject;

import java.util.Map;
import java.util.HashMap;
import java.util.Collection;
import java.io.File;
import java.io.FileWriter;
import java.io.FileReader;
import java.io.IOException;
import java.util.Properties;
import java.lang.System;

/**
 * @author mnankman
 */

public class ConfigVO {
    
    var accounts:Map = new HashMap();
    public var numAccounts = bind accounts.size();
    
    public var twitterAPISettings = TwitterAPISettingsVO {
        getDirectMessagesInterval: 1m
        getFriendTimelineInterval: 1m
        getUserTimelineInterval: 1m
        getRepliesInterval: 1m
    };
    
    public function addAccount(account:AccountVO) {
        accounts.put(account.id, account);
    }
    
    public function getAccounts(): Collection {
        return accounts.values();
    }

    public function getAccount(id:String): AccountVO {
        return accounts.get(id) as AccountVO;
    }
    
    public function updateAccount(updatedAccount:AccountVO) {
        if (accounts.containsKey(updatedAccount.id)) {
            var account = accounts.get(updatedAccount.id) as AccountVO;
            account.login = updatedAccount.login;
            account.password = updatedAccount.password;
        }
        else {
            accounts.put(updatedAccount.id, updatedAccount);
        }
    }

    public function save() {
        try {
            var configFile = new File("{System.getProperty("user.home")}/tweetbox.properties");
            System.out.println("saving config to: {configFile.getPath()}");
            var config:Properties = new Properties();
            var outStream:java.io.OutputStream = new java.io.FileOutputStream(configFile);
            var account = getAccount("twitter");
            config.setProperty("twitter.login", account.login);
            config.setProperty("twitter.password", account.password);
            config.store(outStream, "TweetBox properties");
            System.out.println("config saved to: {configFile.getPath()}");
        }
        catch (e:IOException) {
            System.out.println("could not save config. Cause: {e}");
        }
    }
    
    public function load() {
        try {
            var configFile = new File("{System.getProperty("user.home")}/tweetbox.properties");
            System.out.println("loading config from: {configFile.getPath()}");
            var config:Properties = new Properties();
            var inStream:java.io.InputStream = new java.io.FileInputStream(configFile);
            config.load(inStream);
            System.out.println("config loaded from: {configFile.getPath()}");
            var account = AccountVO {
                id: "twitter"
                login: config.getProperty("twitter.login") as String
                password: config.getProperty("twitter.password") as String
            }
            addAccount(account);
        }
        catch (e:IOException) {
            System.out.println("could not load config. Cause: {e}");
        }
    }
}
