pack200 --repack dist\TweetBox.jar
pack200 --repack dist\lib\JFXtras-0.1.1b.jar
pack200 --repack dist\lib\twitter4j-1.1.4.jar

jarsigner -keystore "http://www.xs4all.nl/~mnankman/tweetbox/keystore" -verbose -keypass tweetbox -storepass tweetbox dist\TweetBox.jar mnankman

jarsigner -keystore "http://www.xs4all.nl/~mnankman/tweetbox/keystore" -verbose -keypass tweetbox -storepass tweetbox dist\lib\JFXtras-0.1.1b.jar mnankman

jarsigner -keystore "http://www.xs4all.nl/~mnankman/tweetbox/keystore" -verbose -keypass tweetbox -storepass tweetbox dist\lib\twitter4j-1.1.4.jar mnankman

pause