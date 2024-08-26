# EcoflowAPItoMQTT
 Using the Ecoflow API to send to MQTT/Home Assistant

Uses the API from https://developer-eu.ecoflow.com/  - it takes a couple of days from sign up to get an api key

The Python script to get data from an Delta 2 Max - the code can be adapted for other models and other techniques to share the data.

It is used to read the Solar Input, Output and Battery level, this is published to MQTT and then read into Home Assistant.
