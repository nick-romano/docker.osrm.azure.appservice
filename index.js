var express = require('express');
const bodyParser = require('body-parser');
var fetch = require('node-fetch');
var app = express();

var port = 3000;
var forwardPort = 5000;

app.use(bodyParser.json({ limit: '2000mb' }));
app.use(bodyParser.urlencoded({ extended: true,  limit: '2000mb' })) // for parsing application/x-www-form-urlencoded

app.get('*', function (req, res) {
    const path = `http://localhost:${forwardPort}${req.path}`;
    console.log(path);
    try {
        fetch(path).then(r => r.json()).then(r => {
            res.send(r);
        })
    } catch (e) {
        res.status(500);
    }
});

app.post('*', function (req, res) {
    const params = req.body.params;
    const path = `http://localhost:${forwardPort}${req.path}${params}`;
    try {
        fetch(path).then(r =>
            r.json()
        ).then(r => {
            res.send(r);
        });
    } catch (e) {
        res.status(500);
    }
});

app.listen(port, () => {
    console.log(`app listening at http://localhost:${port}`)
})