/*
 * Config.fx
 *
 * Created on 8-nov-2008, 21:05:11
 */

package tweetbox.model;

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

public class Config {
    
    private attribute accounts:Map = new HashMap();
    public attribute numAccounts = bind accounts.size();
    
    public attribute twitterAPISettings = TwitterAPISettings {
        getDirectMessagesInterval: bind 5m
        getFriendTimelineInterval: bind 10s
        getRepliesInterval: bind 5m
    };
    
    public function addAccount(account:Account) {
        accounts.put(account.id, account);
    }
    
    public function getAccounts(): Collection {
        return accounts.values();
    }

    public function getAccount(id:String): Account {
        return accounts.get(id) as Account;
    }
    
    public function updateAccount(updatedAccount:Account) {
        if (accounts.containsKey(updatedAccount.id)) {
            var account = accounts.get(updatedAccount.id) as Account;
            account.login = updatedAccount.login;
            account.password = updatedAccount.password;
        }
        else {
            accounts.put(updatedAccount.id, updatedAccount);
        }
    }

    public function save() {
        var configFile = new File(System.getProperty("user.home")+"/tweetbox.properties");
        System.out.println("saving config to: " + configFile.getPath());
        var config:Properties = new Properties();
        var account = getAccount("twitter");
        config.setProperty("twitter.login", account.login);
        config.setProperty("twitter.password", account.password);
        try {
            config.store(new FileWriter(configFile), "TweetBox properties");
            System.out.println("config saved to: " + configFile.getPath());
        }
        catch (e:IOException) {
            System.out.println("could not save config. Cause: " + e);
        }
    }
    
    public function load() {
        var configFile = new File(System.getProperty("user.home")+"/tweetbox.properties");
        System.out.println("loading config from: " + configFile.getPath());
        var config:Properties = new Properties();
        try {
            config.load(new FileReader(configFile));
            System.out.println("config saved to: " + configFile.getPath());
            var account = Account {
                id: "twitter"
                login: config.getProperty("twitter.login") as String
                password: config.getProperty("twitter.password") as String
            }
            addAccount(account);
        }
        catch (e:IOException) {
            System.out.println("could not load config. Cause: " + e);
        }
    }
}
