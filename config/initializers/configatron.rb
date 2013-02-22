require 'configatron'
Configatron::Rails.init

configatron.gcm_on_rails.api_url = 'https://android.googleapis.com/gcm/send'
configatron.gcm_on_rails.api_key = 'AIzaSyB8DMKpnr0KG-dgWFY9DDnzrJ2_iEVPulQ'
configatron.gcm_on_rails.app_name = 'org.in2teck.codice.AdivinaMe'
configatron.gcm_on_rails.delivery_format = 'json'
