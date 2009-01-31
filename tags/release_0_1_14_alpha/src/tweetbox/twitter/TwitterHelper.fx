/*
 * TwitterHelper.fx
 *
 * Created on 28-jan-2009, 22:26:14
 */

package tweetbox.twitter;

import java.util.Calendar;
import java.util.List;
import java.util.Date;

import twitter4j.Status;

/**
 * @author mnankman
 */
public function getSinceDate(statuses:List): Date {
    var cal:Calendar = Calendar.getInstance();
    if (statuses != null and statuses.size() > 0) {
        var status:Status = statuses.get(0) as Status;
        cal.setTime(status.getCreatedAt());
    }
    else {
        cal.add(Calendar.HOUR_OF_DAY, -24);
    }
    return cal.getTime();
}



