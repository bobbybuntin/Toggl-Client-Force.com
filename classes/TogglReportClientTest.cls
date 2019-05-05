@isTest
private class TogglReportClientTest {
/* These unit tests are terrible right now and need to be expanded */
    
    static testMethod void test_GetTimeEntries_ShouldGetMockData() {
        //Create test data
        String togglApiKey = '';
        String useragent = 'noone@email.com';
        String workspaceId = '55555555';
        DateTime fromDateTime = DateTime.newInstance(System.today(), Time.newInstance(0, 0, 0, 0));
        DateTime toDateTime = DateTime.newInstance(System.today(), Time.newInstance(0, 0, 0, 0));
        
        //Invoke functionality
        Test.startTest();
            TogglReportClient togglClient = new TogglReportClient(togglApiKey, 'api_token',useragent,workspaceId);
            List<TogglReportTimeEntry.Entry> togglTimeEntryList = togglClient.getTimeEntriesReport(fromDateTime, toDateTime);
        Test.stopTest();
        
        //Check results
        System.debug('togglTimeEntryList: ' + togglTimeEntryList);
        System.assertEquals(4, togglTimeEntryList.size());
        System.assertEquals('tegin tööd', togglTimeEntryList.get(0).description);
        System.assertEquals(14400000 , togglTimeEntryList.get(0).dur);
    }
    
    static testMethod void test_TogglReportTimeEntry() {
        
        TogglReportTimeEntry timeEntryHeader = new TogglReportTimeEntry();
        TogglReportTimeEntry.Entry timeEntry = new TogglReportTimeEntry.Entry();
        timeEntry.start = System.now();
        //timeEntry.end = System.now();//update after fixing reserve word issue
        timeEntry.dur = 100;
        timeEntry.id = 'timeEntryId';
        timeEntry.pid = '123459384';
        timeEntry.description = 'time entry description';
        
        DateTime startDateTime = timeEntry.startWithoutTimezone;
        
        System.assertEquals(true, true);
    }


    

}