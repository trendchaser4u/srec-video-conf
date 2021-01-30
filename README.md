[![License badge](https://img.shields.io/badge/license-Apache2-orange.svg)](http://www.apache.org/licenses/LICENSE-2.0)

Videoconference app allowing users to make videoconference calls with many of the capabilities

Local Demo setup:

docker run -p 4443:4443 --rm -e OPENVIDU_SECRET=PASS openvidu/openvidu-server-kms:2.16.0
OPENVIDUAPP

Local Demo setup(recording):

docker run -p 4443:4443 --rm -e OPENVIDU_SECRET=MY_SECRET -e OPENVIDU_RECORDING=true -e OPENVIDU_RECORDING_PATH=/opt/openvidu/recordings -v /var/run/docker.sock:/var/run/docker.sock -v /opt/openvidu/recordings:/opt/openvidu/recordings openvidu/openvidu-server-kms:2.16.0

Dashboard:

OPENVIDUAPP/MY_SECRET