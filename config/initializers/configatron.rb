require 'configatron'
Configatron::Rails.init

configatron.gcm_on_rails.api_url = 'https://android.googleapis.com/gcm/send'
configatron.gcm_on_rails.api_key = 'AIzaSyB8DMKpnr0KG-dgWFY9DDnzrJ2_iEVPulQ'
configatron.gcm_on_rails.app_name = 'org.in2teck.codice.AdivinaMe'
configatron.gcm_on_rails.delivery_format = 'json'

# PROD ENVIRONMENT
configatron.apn.cert = "config/apple_push_notification_production.pem"
configatron.apn.feedback.cert = "config/apple_push_notification_production.pem"
configatron.apn.feedback.host = "feedback.push.apple.com"
configatron.apn.feedback.passphrase = ""
configatron.apn.feedback.port = 2196
configatron.apn.host = "gateway.push.apple.com"
configatron.apn.passphrase = ""
configatron.apn.port = 2195

#configatron.apn.cert = "config/apple_push_notification_development.pem"
#configatron.apn.feedback.cert = "config/apple_push_notification_development.pem"
#configatron.apn.feedback.host = "feedback.sandbox.push.apple.com"
#configatron.apn.feedback.passphrase = ""
#configatron.apn.feedback.port = 2196
#configatron.apn.host = "gateway.sandbox.push.apple.com"
#configatron.apn.passphrase = ""
#configatron.apn.port = 2195
