
Toggl Time Entry Retrieval via Toggl Reports API
Based on chexxor's Toggl-Client-Force.com
======================

### What is this?

Toggl is a nice web app that helps you keep track of where you're spending your time.

I needed to synchronize Toggl time entries into my Salesforce org, so I modified this sample Toggl retreival code to work with the newest Toggl Report API.

This API was built to only request a list of time entries from Toggl, but Toggl has a much more [extensive API](https://www.toggl.com/public/api). 

Why the Reports API and not the Toggl API?
The Toggl API only pulls time entries for the user whose API key is used to pull the data.  That's great if you want each user to pull only their own data or if you are the only user.

The Toggl Reports API will pull the time entries for every user in a workspace, allowing one transaction to retrieve everyone's time entires.


### Installation

These classes can be used to retrieve data from the API.  
It includes a remote site setting you can use.
There is no front-end for these classes.  You must write your own controller, class or execute anonymous to try it out.
There are custom settings for the class (included).  You must provide values for the custom settings specific to your Toggl user account.


### How to Use




### Problems?

Three options
- Let me know by making an issue on GitHub.
- Fix it yourself and submit a pull request on GitHub.
- Find some other way to message me on the internet.


### Open Source

Copyright (c) <year> <copyright holders>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
