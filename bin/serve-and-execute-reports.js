#!/usr/bin/node
import express from 'express'
import child_process from 'child_process'

child_process.execSync('run-test-in-virtual-screen.sh', {
    env: process.env,
    pwd: __dirname,
    stdio: [0, 1, 2]
});

if (process.env.SERVE_REPORTS === 1) {

    const app = express()
    // Define the port to run on
    app.set(`port`, 3000)

    app.use(express.static(`${process.env.ROBOTFRAMEWORK_PATH}/reports`))
    // Listen for requests
    var server = app.listen(app.get(`port`), function () {
        var port = server.address().port
        console.log(`Magic happens on port ${port}`)
    })
} else {

    // exit gracefully
    console.log(`No serving of reports, they are available in  ${process.env.ROBOTFRAMEWORK_PATH}/reports`)

}

process.exit(0)
