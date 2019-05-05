/*New custom class to catch Toggl Report API data for the detail report.  
 * For format, see:  https://github.com/toggl/toggl_api_docs/blob/master/reports.md
 * */

public class TogglReportTimeEntry {
    public Integer total_grand, total_billable,total_count,per_page;
    public Entry[] data;
    public class Entry {
        public String id,pid,tid,uid,description,user,client,project;
        public Datetime start,updated;//TODO add support for 'end'parameter, which is an APEX reserved word.
        public Integer dur;//duration in milliseconds
        public boolean is_billable;
        
     public DateTime startWithoutTimezone {
        get {
            DateTime startGmt = this.start;
            if (startGmt == null)
                return null;
            
            TimeZone userTimezone = UserInfo.getTimeZone();
            Integer offsetFromGmtInMs = userTimezone.getOffset(startGmt);
            Integer offsetFromGmtInHr = offsetFromGmtInMs / 1000 / 3600;
            //Integer offsetFromGmtInHr = -6;
            DateTime startLocal = startGmt.addHours(offsetFromGmtInHr);
            return startLocal;
        }
    }    
    }

   
}