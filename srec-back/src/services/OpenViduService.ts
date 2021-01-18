import { HttpClientService } from './HttpClientService';

export class OpenViduService {

    private httpClientService: HttpClientService;

	constructor(){
        this.httpClientService = new HttpClientService();
    }

	public async createSession(sessionId: string, openviduUrl: string, openviduSecret: string ): Promise<any> {
        const url = openviduUrl + '/api/sessions';
        console.log("Requesting session to ", url);
        const body: string = JSON.stringify({ customSessionId: sessionId, recordingMode: "MANUAL"});

        return await this.httpClientService.post(body, url, openviduSecret);
	}

	public async createToken(sessionId: string, openviduUrl: string, openviduSecret: string ): Promise<any> {
		const url = openviduUrl + '/api/tokens';
        console.log("Requesting token to ", url);
        const body: string = JSON.stringify({ session: sessionId });

        return await this.httpClientService.post(body, url, openviduSecret);
    }

    public async startRecording(sessionId: string, openviduUrl: string, openviduSecret: string ): Promise<any> {
		const url = openviduUrl + '/api/recordings/start';
        console.log("Start recording");
        const body: string = JSON.stringify({ session: sessionId, outputMode: "COMPOSED", recordingLayout: "BEST_FIT" });
        try{
            return await this.httpClientService.post(body, url, openviduSecret);
        }catch (error) {
			throw error;
		}
    }

    public async stopRecording(recordingId: string, openviduUrl: string, openviduSecret: string ): Promise<any> {
		const url = openviduUrl + '/api/recordings/stop/'+recordingId;
        console.log("Stop recording");
        const body: string = JSON.stringify({});
        try{
            return await this.httpClientService.post(body, url, openviduSecret);
        }catch (error) {
			throw error;
		}
    }
}