/*
 * VersionVO.fx
 *
 * Created on 25-jan-2009, 15:00:30
 */

package tweetbox.valueobject;

/**
 * @author mnankman
 */

public class AppInfoVO {
    public-init var name = "TweetBox";
    public-init var build = 0;
    public-init var major = 0;
    public-init var minor = 2;
    public-init var revision = 0;
    public-init var info = "alpha";
    public-init var versionString = "{major}.{minor}.{build} ({info})";
    public-init var title = "{name} {versionString}";

    public-init var licence = "Mozilla Public Licence 1.1";
    public-init var jnlpUrl = "http://webstart.tweetbox.org/";
    public-init var libraries = "Twitter4J 1.1.7, JFXtras 0.3";
    public-init var javafx = "JavaFX SDK 1.1.1";

    // system info
    public-init var javaVersion = java.lang.System.getProperty("java.version");
    public-init var vmVendor = java.lang.System.getProperty("java.vm.vendor");
    public-init var vmName = java.lang.System.getProperty("java.vm.name");
    public-init var vmVersion = java.lang.System.getProperty("java.vm.version");
    public-init var osName = java.lang.System.getProperty("os.name");
    public-init var osVersion = java.lang.System.getProperty("os.version");

}
