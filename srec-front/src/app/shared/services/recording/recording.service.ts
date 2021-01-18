import { Injectable } from '@angular/core';
import { LoggerService } from '../logger/logger.service';
import { ILogger } from '../../types/logger-type';
import { NotificationService } from '../notifications/notification.service';
import { OpenViduWebrtcService } from '../openvidu-webrtc/openvidu-webrtc.service';
import { LocalUsersService } from '../local-users/local-users.service';
import { Observable } from 'rxjs/internal/Observable';
import { BehaviorSubject } from 'rxjs/internal/BehaviorSubject';
import { NetworkService } from '../network/network.service';
import { TokenService } from '../token/token.service';

@Injectable({
    providedIn: 'root'
})
export class RecordingService {

    private log: ILogger;
    recordingState: Observable<boolean>;
    private _recordingState = <BehaviorSubject<boolean>>new BehaviorSubject(false);

    constructor(
        private loggerSrv: LoggerService,
        private openViduWebRTCService: OpenViduWebrtcService,
        private localUsersService: LocalUsersService,
        private notificationService: NotificationService,
        private networkSrv: NetworkService,
        private tokenService: TokenService
    ) {
        this.log = this.loggerSrv.get('ChatService');
        this.recordingState = this._recordingState.asObservable();
    }

    subscribeToRecording() {
        const session = this.openViduWebRTCService.getWebcamSession();
        session.on('signal:recording', (event: any) => {
            const connectionId = event.from.connectionId;
            const data = JSON.parse(event.data);
            const isMyOwnConnection = this.openViduWebRTCService.isMyOwnConnection(connectionId);
            if (!isMyOwnConnection) {
                if (data.cmd === "START") {
                    this._recordingState.next(true);
                } else if (data.cmd === "STOP") {
                    this._recordingState.next(false);
                }
            }
            this.notificationService.recordingNotify(data.message, () => { });
        });
    }

    sendRecordingSignal(cmd: string, message: string) {
        message = message.replace(/ +(?= )/g, '');
        if (message !== '' && message !== ' ') {
            const data = {
                cmd: cmd,
                message: message,
                nickname: this.localUsersService.getWebcamUserName()
            };
            const sessionAvailable = this.openViduWebRTCService.getSessionOfUserConnected();
            sessionAvailable.signal({
                data: JSON.stringify(data),
                type: 'recording'
            });
        }
    }

    enableRecording() {
        this.networkSrv.startRecording(this.tokenService.getSessionId()).then((response) => {
            this._recordingState.next(true);
            this.sendRecordingSignal("START", "Recording started successfully.");
        });
    }

    disableRecording() {
        this.networkSrv.stopRecording(this.tokenService.getSessionId()).then((response) => {
            this._recordingState.next(false);
            this.sendRecordingSignal("STOP", "Recording stopped successfully.");
        });
    }
}
