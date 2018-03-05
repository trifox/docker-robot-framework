#!/bin/nodejs
import express from 'express'
const app = express()

// Define the port to run on
app.set('port', 3000)

app.use(express.static('/opt/robotframework/reports'))
// Listen for requests
var server = app.listen(app.get('port'), function () {
    var port = server.address().port
    console.log('Magic happens on port ' + port)
})
