/*
Format:
"directory": {
  "name": "The name to display",
  "description": "About this addon",
  "config" {
    
  }
}

*/

addons = {}
addons["show_incidents"] = {
  "display":"Show recent incidents",
  "config": {
    "api_key": {
      "type":"apikey", 
      "display": "Read-only API Key"
    }
  }
}
addons["account_overview"] = {
  "display":"Account Overview",
  "description":"Show an overview of the account configuration",
  "config": {
    "api_key": {
      "type":"apikey", 
      "display": "Read-only API Key"
    }
  }
}
addons["incident_density"] = {
  "display":"Incident Density",
  "description": "Display a graph showing the denisty of incidents by time of day and day of week",

  "config": {
    "api_key": {
      "type":"apikey", 
      "display": "Full access API Key"
    }
  }
}
addons["vendor_status"] = {
  "display":"Show upstream statuses",
  "description": "Uses <a href='https://statusbot.io'>Statusbot.io</a> to combine & display the statuses of various services from their status pages.",
  "config": {
    "vendors": {
      "type":"multiselect", 
      "display": "Select your vendors",
      "values": {"pagerduty": "PagerDuty", "airbrake":"Airbrake", "atlassian":"Atlassian", "cloudflare":"CloudFlare", "fastly":"Fastly", "iron":"Iron.io", "mailgun": "Mailgun"}
    }
  }
}
addons["pagerduty_status"] = {
  "display":"PagerDuty Status",
  "description": "Display's PagerDuty's status page inline",
  "url":"https://status.pagerduty.com"
}
addons["on_call_hero"] = {
  "display":"On Call Hero",
  "description": "The first... and likely only game based on PagerDuty.  "
}

addons["test"] = {
  "display":"Test",
  "description":"Just a test, ignore this one",
  "url":"http://pagerduty.github.io/addons/install.html",
  "config": {
    "api_key": {
      "display": "API Key:",
      "type":"apikey",       
    },
    "text": {
      "display": "Text:",
    },
    "select": {
      "display": "Select:",
      "type":"select",
      "values": {"pagerduty": "PagerDuty", "atlassian":"Atlassian"}
    },
    "multiselect": {
      "display": "Multiselect:",
      "type":"multiselect",
      "values": {"pagerduty": "PagerDuty", "atlassian":"Atlassian"}
    }    

  }
}