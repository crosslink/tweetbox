/*
 * Config.fx
 *
 * Created on 8-nov-2008, 21:05:11
 */

package tweetbox.configuration;

import javafx.geometry.Rectangle2D;
import javafx.geometry.Point2D;

import java.util.Map;
import java.util.HashMap;
import java.util.Collection;
import java.io.File;
import java.io.FileWriter;
import java.io.FileReader;
import java.io.IOException;
import java.util.Properties;
import java.lang.System;

import tweetbox.valueobject.*;

/**
 * @author mnankman
 */

public class Configuration {
    
    var accounts:Map = new HashMap();

    public var groups:GroupVO[];

    public var numAccounts = bind accounts.size();
    
    public var twitterAPISettings = TwitterAPISettingsVO {
        getDirectMessagesInterval: 5m
        getFriendTimelineInterval: 5m
        getUserTimelineInterval: 1h
        getRepliesInterval: 5m
    };

    public var applicationStage:javafx.stage.Stage;
    
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

            config.setProperty("application.bounds.height", "{applicationStage.height}");
            config.setProperty("application.bounds.width", "{applicationStage.width}");
            config.setProperty("application.bounds.x", "{applicationStage.x}");
            config.setProperty("application.bounds.y", "{applicationStage.y}");
            
            for (group:GroupVO in groups) {
                config.setProperty("group.{group.id}.expanded", "{group.expanded}");
            }

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

            try {
                applicationStage.x = new java.lang.Double(config.getProperty("application.bounds.x")).doubleValue();
                applicationStage.y = new java.lang.Double(config.getProperty("application.bounds.y")).doubleValue();
                applicationStage.width = new java.lang.Double(config.getProperty("application.bounds.width")).doubleValue();
                applicationStage.height = new java.lang.Double(config.getProperty("application.bounds.height")).doubleValue();
            } catch (e:java.lang.NumberFormatException) {
                println(e);
            }

            for (group:GroupVO in groups) {
                group.expanded = new java.lang.Boolean(config.getProperty("group.{group.id}.expanded")).booleanValue();
            }
        }
        catch (e:IOException) {
            println("could not load config. Cause: {e}");
        }
    }
}
