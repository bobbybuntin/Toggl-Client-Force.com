public with sharing class TogglReportClient {

    
    public static final String DATE_FORMAT = 'yyyy-MM-dd\'T\'HH:mm:ss';
    public static final String DATA = 'data';
    
    private final static String TIME_ENTRIES_ENDPOINT = 'https://www.toggl.com/api/v8/time_entries';
    private final static String DETAIL_REPORT_ENDPOINT = 'https://toggl.com/reports/api/v2/details';
    
    
    public static HttpResponse mockTogglResponse = null;

    private String user {get; set;}
    private String password {get; set;}
    private String userAgent {get; set;}//email address for a company point of contact
    private String workspaceId {get; set;}//Toggl's workspace id of the Toggl workspace containing the time entries

    //Constructor to create an instance of Toggl
    // @param user username or api_token
    // @param password password or string 'api_token'
    
    public TogglReportClient(String user, String password, String userAgent, String workspaceId) {
        this.user = user;
        this.password = password;
        this.userAgent = userAgent;
        this.workspaceId = workspaceId;
    }
    
    public List<TogglReportTimeEntry.Entry> getTimeEntriesReport(DateTime startDate, DateTime endDate) {

        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        
        System.debug('startDate: ' + TogglReportClient.convertDateToString(startDate));
        System.debug('endDate: ' + TogglReportClient.convertDateToString(endDate));

        String authHeader = TogglReportClient.buildAuthHeader(this.user, this.password);
        req.setHeader('Authorization', authHeader);
        
        String endpointWithQuery = TogglReportClient.appendQueryReport(TogglReportClient.DETAIL_REPORT_ENDPOINT, startDate, endDate,this.userAgent,this.workspaceId);
        req.setEndpoint(endpointWithQuery);
        System.debug('req: ' + req);
        
        //Make callout.
        Http http = new Http();
        HttpResponse res = null;
        if (Test.isRunningTest()) {
            HttpResponse mockResponse = null;
            if (TogglReportClient.mockTogglResponse != null)
                mockResponse = TogglReportClient.mockTogglResponse;
            else {
                mockResponse = TogglReportClient.createMockTogglTimeEntriesResponse();
            }
            res = mockResponse;
        }
        else {
            try {
                res = http.send(req);
            }
            catch (Exception e) {
                res = new HttpResponse();
                res.setBody (e.getMessage());
                res.setStatus('ERROR');
                res.setStatusCode(405);
            }
        }
        
        String resBody = res.getBody(); 
       
         
        System.debug('resBody: ' + resBody);
        
        if (resBody.startsWith('Unauthorized endpoint')) {
            throw new TogglClientException(resBody);
        }
        
        //Turn the response into a JSON object.
 		TogglReportTimeEntry togglTimeReport = (TogglReportTimeEntry)JSON.deserialize(resBody,TogglReportTimeEntry.class);
        List<TogglReportTimeEntry.Entry> togglTimeEntryList = togglTimeReport.data;
        
        //The api paginates the response, so make additional calls to get subsequent result pages.
        If (togglTimeReport.total_count > togglTimeReport.per_page)
        {
            Integer totalPages = (Integer)Math.ceil((decimal)togglTimeReport.total_count / togglTimeReport.per_page);
            for (Integer i = 2; i <= totalPages; i++)
            {
                endpointWithQuery 
                += '&page=' + i;
                
                req.setEndpoint(endpointWithQuery);
                
                System.debug('req: ' + req);
                
                //Make callout.
                //Http http = new Http();
                //HttpResponse res = null;
                if (Test.isRunningTest()) {
                    HttpResponse mockResponse = null;
                    if (TogglReportClient.mockTogglResponse != null)
                        mockResponse = TogglReportClient.mockTogglResponse;
                    else {
                        mockResponse = TogglReportClient.createMockTogglTimeEntriesResponse();
                    }
                    res = mockResponse;
                }
                else {
                    try {
                        res = http.send(req);
                    }
                    catch (Exception e) {
                        res = new HttpResponse();
                        res.setBody (e.getMessage());
                        res.setStatus('ERROR');
                        res.setStatusCode(405);
                    }
                }
                
                resBody = res.getBody(); 
                
                
                System.debug('resBody: ' + resBody);
                
                if (resBody.startsWith('Unauthorized endpoint')) {
                    throw new TogglClientException(resBody);
                }
                
                togglTimeReport = (TogglReportTimeEntry)JSON.deserialize(resBody,TogglReportTimeEntry.class);
                togglTimeEntryList.addAll(togglTimeReport.data);
                
            }
            
        }
        
        System.debug('togglTimeEntryList: ' + togglTimeEntryList);
        System.debug('Total records from report: ' + togglTimeReport.total_count);
        System.debug('Total records in TimeEntryList: ' + togglTimeEntryList.size());

 
        return togglTimeEntryList;

    }

    public static String buildAuthHeader(String username, String password) {
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String base64Credentials = EncodingUtil.base64Encode(headerValue);
        String authHeader = 'Basic ' + base64Credentials;
        return authHeader;
    }

    //Add required parameters to the query URL
        public static String appendQueryReport(String endpoint, DateTime startDate, DateTime endDate, String userAgent, String workspaceId) {
        String endpointWithQuery = endpoint;
        if (startDate != null && endDate != null)
            endpointWithQuery 
                += '?since=' + TogglReportClient.convertDateToString(startDate)
                + '&until=' + TogglReportClient.convertDateToString(endDate)
            	+ '&user_agent=' + userAgent
            	+ '&workspace_id=' + workspaceId;
        return endpointWithQuery;
    }
/*
    public static DateTime convertStringToDate(String dateString) {
        DateTime dateT = DateTime.parse(dateString);
        return dateT;
    }
    */
    public static String convertDateToString(DateTime dateT) {
        
        TimeZone userTimezone = UserInfo.getTimeZone();
        Integer offsetFromGmtInMs = userTimezone.getOffset(dateT);
        Integer offsetFromGmtInHr = offsetFromGmtInMs / 1000 / 3600;
        //Integer offsetFromGmtInHr = -6;//deactivated to use dynamic timezone based on user
        String offsetFromGmtInHrFormatted = String.valueOf(offsetFromGmtInHr) + ':00';
        System.debug('offsetFromGmtInHrFormatted: ' + offsetFromGmtInHrFormatted);
        System.debug('offsetFromGmtInHrFormatted.length(): ' + offsetFromGmtInHrFormatted.length());
        if (offsetFromGmtInHrFormatted.length() == 5) {
            offsetFromGmtInHrFormatted = offsetFromGmtInHrFormatted.replace('-', '-0');
            offsetFromGmtInHrFormatted = offsetFromGmtInHrFormatted.replace('+', '+0');
        }
        return dateT.format(TogglReportClient.DATE_FORMAT) + offsetFromGmtInHrFormatted;
        //return dateT.format(TogglClient.DATE_FORMAT);
    }
    
    public static HttpResponse createMockTogglTimeEntriesResponse() {
        HttpResponse mockRes = new HttpResponse();
        mockRes.setStatus('OK');
        mockRes.setStatusCode(200);
       //mock response taken from the toggl api documentation sample response, except per_page changed from 50
       //to 1 so that two mock calls will be made (for code coverage of the pagination handling).
        String mockTogglResponseBody = '{"total_grand":23045000,"total_billable":23045000,"total_count":2,"per_page":1,"total_currencies":[{"currency":"EUR","amount":128.07}],'
           + ' "data":[{"id":43669578,"pid":1930589,"tid":null,"uid":777,"description":"tegin tööd","start":"2013-05-20T06:55:04","end":"2013-05-20T10:55:04","updated":"2013-05-20T13:56:04","dur":14400000,"user":"John Swift","use_stop":true,"client":"Avies","project":"Toggl Desktop","task":null,"billable":8.00,"is_billable":true,"cur":"EUR","tags":["paid"]},{'
           + '"id":43669579,"pid":1930625,"tid":1334973,"uid":7776,"description":"agee","start":"2013-05-20T09:37:00","end":"2013-05-20T12:01:41","updated":"2013-05-20T15:01:41","dur":8645000,"user":"John Swift","use_stop":true,"client":"Apprise","project":"Development project","task":"Work hard","billable":120.07,"is_billable":true,"cur":"EUR","tags":[]}]}';
        mockRes.setBody(mockTogglResponseBody);
        return mockRes;
    }
    
    public class TogglClientException extends Exception {}
}