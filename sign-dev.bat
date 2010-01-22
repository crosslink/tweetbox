pack200 --repack dist\TweetBox.jar
pack200 --repack dist\lib\JFXtras-0.5.jar
pack200 --repack dist\lib\twitter4j-2.0.10.jar
pack200 --repack dist\lib\swing-worker-1.1.jar

jarsigner -keystore "http://www.xs4all.nl/~mnankman/tweetbox/keystore" -verbose -keypass tweetbox -storepass tweetbox dist\TweetBox.jar mnankman

jarsigner -keystore "http://www.xs4all.nl/~mnankman/tweetbox/keystore" -verbose -keypass tweetbox -storepass tweetbox dist\lib\JFXtras-0.5.jar mnankman

jarsigner -keystore "http://www.xs4all.nl/~mnankman/tweetbox/keystore" -verbose -keypass tweetbox -storepass tweetbox dist\lib\twitter4j-2.0.10.jar mnankman

jarsigner -keystore "http://www.xs4all.nl/~mnankman/tweetbox/keystore" -verbose -keypass tweetbox -storepass tweetbox dist\lib\swing-worker-1.1.jar mnankman

pause