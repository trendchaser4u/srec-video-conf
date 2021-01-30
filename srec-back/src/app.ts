
import * as express from 'express';
import { SERVER_PORT, OPENVIDU_URL, OPENVIDU_SECRET, CALL_OPENVIDU_CERTTYPE } from './config';
import { app as callController } from './controllers/CallController';
import * as dotenv from 'dotenv';
var timeout = require('connect-timeout');

dotenv.config();
const app = express();
app.use(timeout('30s'))
app.use(haltOnTimedout);
app.use(express.static('public'));
app.use(express.json());

app.use('/call', callController);

function haltOnTimedout(req, res, next) {
    if (!req.timedout) next()
}

app.listen(SERVER_PORT, () => {
    console.log("---------------------------------------------------------");
    console.log(" ")
    console.log(`OPENVIDU URL: ${OPENVIDU_URL}`);
    console.log(`OPENVIDU SECRET: ${OPENVIDU_SECRET}`);
    console.log(`CALL OPENVIDU CERTTYPE: ${CALL_OPENVIDU_CERTTYPE}`);
    console.log(`OpenVidu Call Server is listening on port ${SERVER_PORT}`);
    console.log(" ")
    console.log("---------------------------------------------------------");
});